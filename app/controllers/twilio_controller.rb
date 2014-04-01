require 'twilio-ruby'

class TwilioController < ApplicationController

  def receive
    Rails.logger.info "Received SMS: #{params}"
    raise "No message body received" unless params[:Body]
    create_order
    head :no_content
  end

  private

  def create_order
    response = begin
      data  = SMS.parse params
      order = Order.create_from_text data
      order.confirmation_message
    rescue SMS::ParseError => e
      I18n.t 'order.unparseable'
    rescue => e
      Rails.logger.info "Error in `create_order`: #{e.message}"
      SMS.friendly e.message
    end
    SMS.new(params[:From], response).deliver
  end

end
