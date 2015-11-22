class TwilioController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token, only: [:receive]
  skip_after_action :verify_authorized, only: :receive

  def receive
    dispatcher = SMS::Receiver.new sid: params[:AccountSid], to: params[:To]
    dispatcher.handle(from: params[:From], body: params[:Body])
    head :ok
  rescue SMS::Receiver::InvalidSid
    Rails.logger.error "Error: rejecting incoming text - invalid SID #{params[:AccountSid]}"
    head :bad_request
  end
end
