class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :api_authenticate!, only: [:login]
  skip_after_action  :verify_authorized

  def login
    user = User.find_for_authentication email: params[:email]
    if user.valid_password?(params[:password])
      user.ensure_secret_key!
      render json: { id: user.id, secret_key: user.secret_key }
    else
      error "Invalid username or password", status: :unauthorized
    end
  end

  def test
    @user = current_user
  end
end
