class RequestsController < ApplicationController
  def new
    @placer = RequestForm.new current_user.submitted_requests.new
    authorize @placer
  end

  def create
    @placer = RequestForm.new current_user.submitted_requests.new

    if save_form @placer, params[:request]
      redirect_to after_create_path, flash: { success: @placer.success_message }
    else
      render :new
    end
  end

  private

  def after_create_path
    current_user.pcv? ? orders_path : root_path
  end
end
