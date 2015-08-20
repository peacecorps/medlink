class TwilioController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token, only: [:receive]

  def receive
    message = SMSDispatcher.new \
      account_sid: params[:AccountSid],
      from:        params[:From],
      to:          params[:To],
      body:        params[:Body]

    if message.valid_sid?
      message.record_and_respond
      head :ok
    else
      Rails.logger.error "Error: rejecting incoming text - invalid SID #{params[:AccountSid]}"
      head :bad_request
    end
  end
end
