class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :send_login_help

  def edit
    @user = current_user
    authorize @user
  end

  def update
    @user = current_user
    authorize @user
    if @user.update_attributes update_params
      redirect_to edit_user_path, flash: { success: I18n.t!("flash.user.account_updated") }
    else
      render :edit
    end
  end

  def welcome_video
    @video = current_user.welcome_video
    authorize @video, :show?
    render :welcome_video
  end

  def confirm_welcome
    current_user.record_welcome!
    authorize current_user, :update?
    redirect_to root_path
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

  private

  def update_params
    p = params.require(:user).permit :first_name, :last_name, :email, :location, :time_zone,
      phones_attributes: [:id, :number, :_destroy]
    p[:phones_attributes].reject! { |_,ps| ps[:number].empty? } if p[:phones_attributes]
    p
  end
end
