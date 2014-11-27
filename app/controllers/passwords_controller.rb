class PasswordsController < Devise::PasswordsController
  def create
    user = User.find_by_email(params[:user][:email])

    unless reset_allowed? user
      flash[:error] = I18n.t! "flash.auth.password_reset_invalid"
      redirect_to new_user_password_path and return
    end
    super
  end

  private

  def pcv_id_required? user
    user.pcv? && user.email !~ /peacecorps.gov$/
  end

  def reset_allowed? user
    return false unless user
    return true unless pcv_id_required?(user)
    user.pcv_id == params[:user][:pcv_id]
  end
end
