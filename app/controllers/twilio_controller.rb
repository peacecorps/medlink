class TwilioController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_authenticity_token

  def receive
    sms = SMS.create number: params[:From], text: params[:Body], direction: :incoming
    sms.create_orders!
    sms.send_confirmation!
  rescue SMS::FriendlyError => e
    SMS.deliver params[:From], e.message
  ensure
    head :no_content
  end
end
