class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  def render_success(message:, data: {}, status: :ok)
    render json: { status: "success", message: message, data: data }, status: status
  end

  def render_error(message:, status: :unprocessable_entity)
    render json: { status: "error", message: message }, status: status
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    decoded = JsonWebToken.decode(header)

    @current_user = User.find(decoded[:user_id])

    render_error(message: "Invalid token", status: :unauthorized) if @current_user.nil?
  end
end
