require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
		# parse gives back and SMS object
    	sms = SMS.parse params

    	if sms.send_now?
    		sms.send
    	else
            create_order sms
		end    
	end

    private

    def create_order sms
        order = Order.create_from_text sms
        SMS.send_from_order order
        
        rescue => e
            SMS.send_error sms, e.message
    end
end
