class PasswordsController < Devise::PasswordsController
  def create
    user = User.find_by_email(params[:user][:email])
    if !user
      flash[:notice] = "Email Invalid: The email you specified is " +
        "invalid. Please check the spelling, formatting and that " +
        "it is an active address."
      redirect_to new_user_password_path and return
    elsif user.pcv_id != params[:user][:pcv_id]
      flash[:notice] = "PCVID Invalid: Your request was not submitted " +
        "because the PCVID was incorrect. Please resubmit your request " +
        "in this format: PCVID, Supply short name, dose, qty, location."
      redirect_to new_user_password_path and return
    end

    self.resource = resource_class.send_reset_password_instructions(
      resource_params)
    if successfully_sent?(resource)
      # P3
      flash[:notice] = "Success! A temporary password has been sent " +
        "to the email we have on file. Please check your e-mail and " +
        "click on the link to complete the log in. (web experience)"
      respond_with({}, :location =>
        after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end
end
