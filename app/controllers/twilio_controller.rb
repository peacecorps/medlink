class TwilioController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_authenticity_token

  def receive
    verify_sid!
    SMS.receive params[:From], params[:Body]
  rescue SMS::FriendlyError => e
    SMS.deliver params[:From], e.message
  rescue
    # :nocov: This _should_ be impossible, but just in cases ...
    SMS.deliver params[:From], I18n.t!("sms.unexpected_error")
    raise
    # :nocov:
  ensure
    head :no_content
  end

  private

  def verify_sid!
    unless params[:AccountSid] == ENV.fetch("TWILIO_ACCOUNT_SID")
      raise "Invalid Account SID"
    end
  end
end
