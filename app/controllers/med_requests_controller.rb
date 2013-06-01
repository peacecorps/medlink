require 'twilio-ruby'

class MedRequestsController < ApplicationController

	def create
		from   = params[:From]
		body   = params[:Body]
		client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH']
		client.account.sms.messages.create(
  			:from => '+17322301185',
  			:to => from,
  			:body => body
		)
	end

end