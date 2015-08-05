class TwilioController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token, only: [:receive]

  def receive
    account = TwilioAccount.where(sid: params[:AccountSid], number: params[:To]).first
    unless account
      Rails.logger.error "Error: Rejecting incoming text - invalid SID #{params[:AccountSid]}"
      head :bad_request
      return
    end

    begin
      SMS.receive params[:From], params[:Body]
    rescue SMS::FriendlyError => e
      account.send_text params[:From], e.message
    rescue
      # :nocov: This _should_ be impossible, but just in cases ...
      account.send_text params[:From], I18n.t!("sms.unexpected_error")
      raise
      # :nocov:
    ensure
      head :no_content
    end
  end
end
