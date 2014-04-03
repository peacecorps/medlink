class TwilioController < ApplicationController
  def receive
    sms = SMS.create number: params[:From], text: params[:Body], direction: :incoming
    orders = sms.create_orders
    sms.send_confirmation orders
  rescue => e
    SMS::Response.new(params[:From], SMS.friendly(e.message)).send
  ensure
    head :no_content
  end
end
