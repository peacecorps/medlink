class RequestsController < ApplicationController
  def new
    @request = RequestForm.new current_user.submitted_requests.new
    authorize @request
  end

  def create
    @request = RequestForm.new current_user.submitted_requests.new
    if save_form @request, params[:request]
      redirect_to after_create_path, flash: { success: @request.success_message }
    else
      render :new
    end
  end

  private

  def after_create_path
    current_user.pcv? ? timeline_path : root_path
  end
end
