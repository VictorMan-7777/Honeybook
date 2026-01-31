class ApplicationController < ActionController::API
  rescue_from ::ActiveRecord::RecordNotFound do
    render json: { error: "Not found" }, status: :not_found
  end

  attr_reader :current_user

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Missing token" }, status: :unauthorized if token.blank?

    payload = JsonWebToken.decode(token)
    @current_user = User.find(payload["user_id"])
  rescue JWT::DecodeError, JWT::ExpiredSignature
    render json: { error: "Invalid or expired token" }, status: :unauthorized
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :unauthorized
  end
end

