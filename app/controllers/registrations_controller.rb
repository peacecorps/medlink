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

  def update
    if current_user.valid_password? params['user']['current_password']
      current_user.update_attribute(:country_id, params['user']['country_id'])
    end
    super
  end
end
