class RequestsController < ApplicationController
  def new
    @placer = RequestForm.new current_user.submitted_requests.new
    authorize @placer
  end

  def create
    @placer = RequestForm.new current_user.submitted_requests.new

    if @placer.validate params[:request]
      # FIXME: we can't authorize until a user is bound, but want to be sure we authorize
      #   in either branch (but before saving here)
      authorize @placer
      @placer.save
      OrderMonitor.new.new_request @placer.model
      redirect_to after_create_path, flash: { success: @placer.success_message }
    else
      authorize @placer
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
