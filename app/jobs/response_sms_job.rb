class ResponseSMSJob < BaseJob
  def perform id
    response = ::Response.find id # not Celluloid::Response
    return unless number = response.user.primary_phone
    sms = SMS.deliver number.display, response.sms_instructions
  end
end
