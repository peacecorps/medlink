class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes update_params
      redirect_to edit_user_path, flash: { success: I18n.t!("flash.account_updated") }
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:user).permit :first_name, :last_name, :email, :location, :time_zone
  end
end
