class SmsJob < ApplicationJob
  def perform phone:, twilio_account:, message:
    UserTexter.new(phone: phone, twilio_account: twilio_account).send message
    true
  end
end
