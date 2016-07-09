class ResponseSMSJob < ApplicationJob
  def perform response
    Medlink.notify Notification::SendingResponse.new response: response
    user = response.user
    return false unless user.try :textable?
    text = ResponseSMSPresenter.new(response).instructions
    sms  = user.send_text text
    response.update! message: sms
    true
  end
end
