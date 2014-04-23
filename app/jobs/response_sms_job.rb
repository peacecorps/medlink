class ResponseSMSJob < BaseJob
  def perform id
    response = ::Response.find id # not Celluloid::Response
    return unless phone = response.user.primary_phone
    sms = SMS.deliver phone.number, response.sms_instructions
  end
end
