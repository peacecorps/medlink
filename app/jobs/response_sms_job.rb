class ResponseSMSJob < BaseJob
  def perform id
    response = Response.find id
    return unless number = response.user.primary_number
    sms = SMS.deliver number.display, response.sms_instructions
  end
end
