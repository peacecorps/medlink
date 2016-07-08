class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :send_login_help
  skip_after_action  :verify_authorized,  only: :send_login_help

  def set_country
    authorize current_user
    current_user.update country: Country.find(params[:country][:id])
    if params[:next]
      redirect_to params[:next]
    else
      redirect_back fallback_location: root_path
    end
  end

  def send_login_help
    email = params[:user][:email]
    unless user = User.find_by_email(email)
      redirect_back fallback_location: new_user_session_path, flash: { error: I18n.t!("flash.email.not_found", email: email) }
      return
    end

    if user.confirmed?
      user.send_reset_password_instructions
    else
      user.send_confirmation_instructions
    end
    redirect_back fallback_location: new_user_session_path, notice: I18n.t!("flash.email.help_sent", email: email)
  end
end
