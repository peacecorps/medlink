class SMSJob < BaseJob
  @queue = :sms

  def self.perform number, message
    SMS.send_raw number, message
  end
end