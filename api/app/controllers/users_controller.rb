class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :register ]

  def register
    # First find the user by email and then update with the other details
    @user = User.find_by!(email_address: user_params[:email_address])

    if @user.update(user_params)
      render_success(message: "#{@user.role.capitalize} account created successfully", status: :created)
    else
      render_error(message: "Account creation failed", status: :unprocessable_entity)
    end
  rescue ActiveRecord::RecordNotFound
    render_error(message: "User not found", status: :not_found)
  end

  def login
    @user = User.find_by!(email_address: user_params[:email_address])

    if @user.authenticate(user_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render_success(message: "Login successful", data: { token: token }, status: :ok)
    else
      render_error(message: "Invalid credentials", status: :unauthorized)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :full_name, :address, :role)
  end
end
