import random

def generate_otp() -> str:
  """Generate a 6-digit OTP as a string."""
  return f"{random.randint(100000, 999999)}"