class Otp < ApplicationRecord
  include BCrypt

  before_create :generate_code_and_expiry

  attr_accessor :raw_code

  def verify?(code)
    return false if self.used
    return false if expires_at <= Time.current

    # Verify the code and status of the otp
    update(used: true) if BCrypt::Password.new(self.otp_digest) == code
  end

  private

  def generate_code_and_expiry
    # Generate a unique 6-digit OTP (retry up to 5 times if duplicate)
    max_attempts = 5
    attempts = 0

    begin
      attempts += 1
      self.raw_code = format("%06d", SecureRandom.random_number(1000000))
      self.otp_digest = BCrypt::Password.create(raw_code)
    end while Otp.exists?(otp_digest: otp_digest) && attempts < max_attempts

    # Set expiry to 10 minutes from now
    self.expires_at = 10.minutes.from_now
  end
end

