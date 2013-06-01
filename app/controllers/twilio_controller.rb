require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
		# parse gives back and SMS object
    	sms = SMS.parse params

    	if sms.send_now?
    		# if sms is ready to be sent
    		sms.send
    	else
    		# sms holds request data
    		request = Request.new sms.data
    		request.save
    		SMS.send_from_request request
		end
    data = SMS.parse params
    order = Order.create_from_text data

    # The Order object and its associated Request may or may not be
    # valid or persisted
    SMS.send_confirmation order
	end
end
