class TwilioController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_authenticity_token

  def receive
    account = TwilioAccount.where(sid: params[:AccountSid]).first
    unless account
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
