class AuthController < ApplicationController
  def register
    user = User.new(register_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user_payload(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email]&.downcase)
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user_payload(user) }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private

  def register_params
    params.permit(:email, :password, :password_confirmation)
  end

  def user_payload(user)
    { id: user.id, email: user.email }
  end
end
