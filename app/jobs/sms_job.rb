class SMSJob < BaseJob
  def perform number, message
    SMS.new(number, message).deliver
  end
end
