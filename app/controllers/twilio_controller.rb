require 'twilio-ruby'

class TwilioController < ApplicationController

  def receive
    Rails.logger.info( "Received SMS: #{params}" )

    case params[:Body]
    when /list/i
      list
    else
      create_order
    end

    head :no_content
  end

  private

  def list
    raise "Not Implemented"
  end

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
