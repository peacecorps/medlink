class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    warden.authenticate!(scope: resource_name, recall: "#{controller_path}#invalid_login_attempt")
    render json: {success: true, user: current_user}
  end

  def destroy
    sign_out(resource_name)
    render json: {success: true}
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render json: {success: false, errors: ["Invalid username or password"], status: 401}
  end
end