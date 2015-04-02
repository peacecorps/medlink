class ResponseSMSJob < ActiveJob::Base
  def perform id
    Rails.logger.info "Sending SMS for response ##{id}"
    response = ::Response.find id # not Celluloid::Response
    user     = response.user
    return unless user.try :textable?
    user.send_text response.sms_instructions
  end
end
