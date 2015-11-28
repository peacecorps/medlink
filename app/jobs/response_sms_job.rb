class ResponseSMSJob < ApplicationJob
  def perform response
    Notification.send :sending_response, "Sending SMS for response ##{response.id}"
    user = response.user
    return false unless user.try :textable?
    text = ResponseSMSPresenter.new(response).instructions
    sms  = user.send_text text
    response.update! message: sms
    true
  end
end
