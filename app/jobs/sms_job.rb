class SMSJob < ActiveJob::Base
  def perform user, message
    user.send_text message
  end
end
