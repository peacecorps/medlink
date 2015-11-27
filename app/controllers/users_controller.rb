class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: :send_login_help
  skip_after_action :verify_authorized, only: :send_login_help

  def timeline
    @timeline = Timeline.new User.find params[:id]
    authorize @timeline, :show?
    render template: "timelines/show"
  end

  def edit
    @user = UserForm.new current_user, editor: current_user
    authorize @user
  end

  def update
    @user = UserForm.new current_user, editor: current_user
    if validate @user, params[:user]
      @user.save
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
end
