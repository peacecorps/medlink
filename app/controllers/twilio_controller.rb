require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
		# parse parameters from twilio
    data = SMS.parse params

    # generate an Order object
    order = Order.from_text data

    # try to save - this may fail, but will send a notice if so
    order.save
    SMS.send_confirmation order
	end
  
end
