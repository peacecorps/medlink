require 'twilio-ruby'

class MedRequestsController < ApplicationController

	def create
		from   = params[:from]
		body   = params[:body]
		client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
		client.account.sms.messages.create(
  			:from => '+17322301185',
  			:to => from,
  			:body => body
		)
	end

end