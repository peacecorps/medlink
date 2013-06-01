require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
    data = SMS.parse params
    order = Order.create_from_text data

    # The Order object and its associated Request may or may not be
    # valid or persisted
    SMS.send_confirmation order
	end
  
end
