class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :send_login_help
  skip_after_action  :verify_authorized,  only: :send_login_help

  def set_country
    authorize current_user
    current_user.update country: Country.find(params[:country][:id])
    redirect_to(params[:next] || :back)
  end

  def send_login_help
    email = params[:user][:email]
    unless user = User.find_by_email(email)
      redirect_to :back, flash: { error: I18n.t!("flash.email.not_found", email: email) }
      return
    end

    if user.confirmed?
      user.send_reset_password_instructions
    else
      user.send_confirmation_instructions
    end
    redirect_to :back, notice: I18n.t!("flash.email.help_sent", email: email)
  end
end
