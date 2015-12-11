class Api::V1::ResponsesController < Api::V1::BaseController
  def mark_received
    response = Response.find params[:id]
    authorize response
    ReceiptTracker.new(response: response, approver: current_user).acknowledge_receipt
    head :ok
  end

  def flag
    response = Response.find params[:id]
    authorize response
    ReceiptTracker.new(response: response, approver: current_user).flag_for_follow_up
    head :ok
  end
end
