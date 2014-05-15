class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes update_params
      redirect_to edit_user_path, flash: { success: I18n.t!("flash.user.account_updated") }
    else
      render :edit
    end
  end

  private

  def update_params
    p = params.require(:user).permit :first_name, :last_name, :email, :location, :time_zone,
      phones_attributes: [:id, :number, :_destroy]
    p[:phones_attributes].reject! { |_,ps| ps[:number].empty? }
    p
  end
end
