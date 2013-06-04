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
    sms   = SMS.parse params
    order = Order.create_from_text sms.data
    SMS.send_from_order order
  rescue SMS::ParseError => e
    SMS.send_raw params[:From], I18n.t('order.unparseable')
  rescue => e
    Rails.logger.info "Error in `create_order`: #{e.message}"
    SMS.send_raw params[:From], e.message
  end

end
