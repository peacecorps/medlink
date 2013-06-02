require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
        Rails.logger.info( params )
		# parse gives back and SMS object
        begin
            Rails.logger.info("Starting create method...")
        	sms = SMS.parse params
            Rails.logger.info(sms.data)
            if sms.send_now?
                sms.send
            else
                create_order sms
            end
        rescue => e
            Rails.logger.info "error in parse: #{e.message}"
            SMS.send_error params[:From], e.message
        end
        head :no_content
	end

    private

    def create_order sms
        order = Order.create_from_text sms.data
        SMS.send_from_order order
        
    rescue => e
        Rails.logger.info "Error in create_order: #{e.message}"
        SMS.send_error sms.data[:phone], e.message
    end
end
