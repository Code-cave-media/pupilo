from fastapi import Depends,HTTPException,APIRouter,Request
from core.deps import get_current_user,get_db
from sqlalchemy.orm import Session
from core.config import settings
from app_subscription.schemas import *
import stripe
import app_subscription.crud as crud_sub
from app_auth.models import User
from datetime import datetime
app = APIRouter()

@app.post('/create-checkout-session')
async def create_session(data:SubscriptionSessionCreate,user:User = Depends(get_current_user),db:Session=Depends(get_db)):
  try:
    db_sub = crud_sub.get_subscription_by_user_id(db,user.id)

    # create new customer id if not exist
    if not db_sub:
        customer = stripe.Customer.create(
            email=user.email,
            name=user.name,
        )
        customer_id = customer["id"]

        # Save to DB
        db_sub =  crud_sub.create_subscription(db,{
          "user_id":user.id,
          "stripe_customer_id":customer_id,
          "status":"not_started",
        })
    session = stripe.checkout.Session.create(
        customer=customer_id,  
        payment_method_types=['card'],
        mode="subscription",
        line_items=[{
            "price": settings.STRIPE_PRICE_ID,
            "quantity": 1
        }],
        subscription_data={
            "trial_period_days": 7 if not db_sub.trial_used else 0
        },
        success_url=data.success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url=data.cancel_url,
    )

    return {"url": session.url}
  except:
    return HTTPException(detail="unable to create session, please try again later",status_code=500)


@app.post('/stripe-webhook')
async def stripe_webhook(request: Request, db: Session = Depends(get_db)):
    payload = await request.body()
    sig_header = request.headers.get("stripe-signature")
    endpoint_secret = settings.STRIPE_WEBHOOK_SECRET

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    except Exception as e:
        print("Webhook error:", e)
        raise HTTPException(detail="Invalid webhook signature", status_code=400)

    # -------------------------------
    # Checkout completed
    # -------------------------------
    if event["type"] == "checkout.session.completed":
        session = event["data"]["object"]
        customer_id = session.get("customer")
        subscription_id = session.get("subscription")

        # fetch subscription object for more details
        subscription = stripe.Subscription.retrieve(subscription_id)

        db_sub = crud_sub.get_subscription_by_customer_id(db,customer_id)

        if db_sub:
            crud_sub.update_subscription(db, db_sub, {
                "stripe_subscription_id": subscription.id,
                "price_id": subscription["items"]["data"][0]["price"]["id"],
                "status": subscription["status"],
                "current_period_end": datetime.fromtimestamp(subscription["current_period_end"]),
                "cancel_at_period_end": subscription["cancel_at_period_end"],
                "trial_used": True  # first subscription → mark trial as used
            })

    # -------------------------------
    # Successful renewal (payment succeeded)
    # -------------------------------
    elif event["type"] == "invoice.payment_succeeded":
        invoice = event["data"]["object"]
        subscription_id = invoice["subscription"]

        subscription = stripe.Subscription.retrieve(subscription_id)

        db_sub = crud_sub.get_subscription_by_subscription_id(db,subscription_id)

        if db_sub:
            crud_sub.update_subscription(db, db_sub, {
                "status": subscription["status"],
                "current_period_end": datetime.fromtimestamp(subscription["current_period_end"]),
                "cancel_at_period_end": subscription["cancel_at_period_end"],
            })

    # -------------------------------
    # Subscription updated (status change, cancel at period end, etc.)
    # -------------------------------
    elif event["type"] == "customer.subscription.updated":
        subscription = event["data"]["object"]
        db_sub = crud_sub.get_subscription_by_subscription_id(db,subscription["id"])
  
        if db_sub:
            crud_sub.update_subscription(db, db_sub, {
                "status": subscription["status"],
                "price_id": subscription["items"]["data"][0]["price"]["id"],
                "current_period_end": datetime.fromtimestamp(subscription["current_period_end"]),
                "cancel_at_period_end": subscription["cancel_at_period_end"],
            })

    # -------------------------------
    # Subscription deleted (fully canceled)
    # -------------------------------
    elif event["type"] == "customer.subscription.deleted":
        subscription = event["data"]["object"]

        db_sub = crud_sub.get_subscription_by_subscription_id(db,subscription["id"])

        if db_sub:
            crud_sub.update_subscription(db, db_sub, {
                "status": "canceled",
                "current_period_end": datetime.fromtimestamp(subscription["current_period_end"]),
                "cancel_at_period_end": subscription["cancel_at_period_end"],
            })

    return {"status": "success"}
