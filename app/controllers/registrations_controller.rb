class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new(params[:user])
    if user.save
      render json: user.as_json(email: user.email), status: 201
      return
    else
      warden.custom_failure!
      render json: user.errors, status: 422
    end
  end

  def edit
    respond_with current_user
  end

  def update
    super
  end
end
