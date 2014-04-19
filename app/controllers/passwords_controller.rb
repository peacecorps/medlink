class PasswordsController < Devise::PasswordsController
  def create
    user = User.find_by_email(params[:user][:email])
    if !user || user.pcv_id != params[:user][:pcv_id]
      flash[:error] = I18n.t! "flash.auth.password_reset_invalid"
      redirect_to new_user_password_path and return
    end
    super
  end
end
