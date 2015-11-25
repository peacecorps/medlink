class RequestsController < ApplicationController
  def new
    @placer = RequestForm.new current_user.submitted_requests.new
    authorize @placer
  end

  def create
    @placer = RequestForm.new current_user.submitted_requests.new

    if validate @placer, params[:request]
      @placer.save
      redirect_to after_create_path, flash: { success: @placer.success_message }
    else
      render :new
    end
  end

  private

  def after_create_path
    if current_user.admin?
      new_admin_user_path
    elsif current_user.pcmo?
      manage_orders_path
    else
      orders_path
    end
  end
end
