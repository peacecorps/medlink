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
	end
end
