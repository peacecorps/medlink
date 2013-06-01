require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
    data  = SMS.parse params
    order = Order.create_from_text data
    SMS.send_confirmation order
  rescue => e
    SMS.send_confirmation e.message
	end
  
end
