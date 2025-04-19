# frozen_string_literal: true

class OtpsController < ApplicationController
  skip_before_action :authenticate_request, only: [ :create_otp, :verify_otp ]

  def create_otp
    permitted = params.permit(:email_address)
    Rails.logger.info("Email address: #{permitted}")
    email_address = permitted[:email_address]

    if email_address.blank?
      return render_error(message: "Email address is required")
    end

    if User.exists?(email_address: email_address)
      return render_error(message: "User already exists")
    end

    otp = Otp.create!
    # Send email with OTP through mailer
    OtpsMailer.send_otp(otp.raw_code, email_address).deliver_later

    render_success(message: "OTP sent successfully")
  end

  def verify_otp
    permitted = params.permit(:email_address, :otp)
    verified = Otp.verify?(permitted[:otp])

    if verified
      render_success(message: "OTP verified successfully")
      # Create a new user account
      User.create!(email_address: permitted[:email_address])
    else
      render_error(message: "Invalid OTP")
    end
  end
end
