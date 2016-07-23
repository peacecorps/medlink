class ResponseNotifier
  def call response
    ResponseSMSJob.perform_later response
    UserMailer.fulfillment(response).deliver_later
  end
end
