class TwilioController < ApplicationController
  skip_before_filter :authenticate_user!, :verify_authenticity_token

  def receive
    sms = SMS.create number: params[:From], text: params[:Body], direction: :incoming
    sms.check_duplicates! 1.hour
    sms.create_orders!
    sms.send_confirmation!
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
end
