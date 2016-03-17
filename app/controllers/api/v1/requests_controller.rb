class Api::V1::RequestsController < Api::V1::BaseController
  def create
    form = RequestForm.new current_user.personal_requests.new
    if save_form form, supplies: params[:supply_ids], text: params[:message]
      @request = form.model
      render :show
    else
      invalid form
    end
  end

  def index
    @requests = current_user.requests
  end
end
