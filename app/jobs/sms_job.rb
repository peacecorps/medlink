class SMSJob < BaseJob
  include SuckerPunch::Job

  def perform number, message
    SMS.new(number, message).deliver
  end
end
