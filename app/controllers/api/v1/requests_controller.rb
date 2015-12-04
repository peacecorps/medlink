class Api::V1::RequestsController < Api::V1::BaseController
  def create
    @request = RequestForm.new current_user.personal_requests.new
    if save_form @request, supplies: params[:supply_ids], text: params[:message]
      render :show
    else
      invalid @request
    end
  end

  def index
    @requests = current_user.requests
  end
end
