class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:login, :phone_login]
  skip_after_action  :verify_authorized

  def login
    user = User.find_for_authentication email: params[:email]
    if user && user.valid_password?(params[:password])
      user.ensure_secret_key!
      render json: { id: user.id, secret_key: user.secret_key }
    else
      error "Invalid username or password", status: :unauthorized
    end
  end

  def phone_login
    p = Phone.find_by condensed: Phone.standardize(params[:number])
    if p && p.user_id && valid_bot_token?
      p.user.ensure_secret_key!
      render json: { id: p.user_id, secret_key: p.user.secret_key }
    else
      error "Invalid phone or token", status: :unauthorized
    end
  end

  def test
    @user = current_user
  end

  private

  def valid_bot_token?
    ActiveSupport::SecurityUtils.secure_compare \
      Figaro.env.telegram_bot_token!, params.fetch(:token, "-")
  end
end
