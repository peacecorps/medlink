require 'twilio-ruby'

class TwilioController < ApplicationController

	def create
		# parse parameters from twilio
    data = SMS.parse params

    # generate a Request object
    request = Request.new data

    # try to save - this may fail, but will send a notice if so
    request.save
    SMS.send request.confirmation
	end
  
end
