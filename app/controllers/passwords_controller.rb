class PasswordsController < Devise::PasswordsController
  def create
    user = User.find_by_email(params[:user][:email])
    if !user
      flash[:error] = Medlink.translate "flash.auth.email_invalid"
      redirect_to new_user_password_path and return
    elsif user.pcv_id != params[:user][:pcv_id]
      flash[:error] = Medlink.translate "flash.auth.pcv_id_invalid"
      redirect_to new_user_password_path and return
    end

    self.resource = resource_class.send_reset_password_instructions(
      resource_params)
    if successfully_sent?(resource)
      flash[:success] = Medlink.translate "flash.auth.password_reset"
      respond_with({}, :location =>
        after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
end
