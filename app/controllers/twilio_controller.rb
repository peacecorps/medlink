require 'twilio-ruby'

class TwilioController < ApplicationController
	def create
		# snag parameters from twilio
		from   = params[:From]
		body   = params[:Body]

		# send SMS
		client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
		client.account.sms.messages.create(
  			:from => '+17322301185',
  			:to => from,
  			:body => body
		)
	end
end
