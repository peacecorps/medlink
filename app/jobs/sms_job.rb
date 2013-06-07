class SMSJob < BaseJob
  @queue = :sms

  def self.perform number, message
    SMS.new(number, message).deliver
  end
end