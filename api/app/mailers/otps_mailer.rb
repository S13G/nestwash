# frozen_string_literal: true

class OtpsMailer < ApplicationMailer
  default from: ENV["DEFAULT_FROM_EMAIL"] || "noreply@example.com"

  def send_otp(otp, email_address)
    @otp = otp
    @email_address = email_address
    mail to: email_address, subject: "Your One Time Password"
  end
end
