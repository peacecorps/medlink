require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
		# parse gives back and SMS object
        begin
        	sms = SMS.parse params
            if sms.send_now?
                sms.send
            else
                create_order sms
            end
        rescue => e
            SMS.send_error params[:From], e.message
        end

        head :ok
	end

    private

    def create_order sms
        order = Order.create_from_text sms
        SMS.send_from_order order
        
    rescue => e
        SMS.send_error sms.data[:phone], e.message
    end
end
