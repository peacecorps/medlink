class ResponseSMSJob < BaseJob
  def perform id
    response = ::Response.find id # not Celluloid::Response
    user     = response.user
    return unless user.try :textable?
    user.send_text response.sms_instructions
  end
end
