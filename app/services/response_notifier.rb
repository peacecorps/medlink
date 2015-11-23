class ResponseNotifier
  def send!
    ResponseSMSJob.perform_later self
    UserMailer.fulfillment(self).deliver_later
  end
end
