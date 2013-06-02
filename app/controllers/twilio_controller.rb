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
            head :ok
        rescue => e
            puts "error in parse"
            SMS.send_error params[:From], e.message
        end
        head :no_content
	end

    private

    def create_order sms
        order = Order.create_from_text sms.data
        SMS.send_from_order order
        
    rescue => e
        puts "Error in create_order"
        SMS.send_error sms.data[:phone], e.message
    end
end
