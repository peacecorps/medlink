class RequestsController < ApplicationController
  def new
    @placer = RequestPlacer.new placed_by: current_user
    authorize @placer.request
  end

  def create
    @placer = RequestPlacer.new \
      placed_by:        current_user,
      for_volunteer_id: params[:request][:for_volunteer_id],
      supply_ids:       params[:request][:supplies],
      message:          params[:request][:message]
    authorize @placer.request

    if @placer.save
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
