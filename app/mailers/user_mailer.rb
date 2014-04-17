class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def forgotten_password id
    User.find(id).send_reset_password_instructions true
  end

  def fulfillment id
    @response = Response.find id
    @subject = "TODO: define subject"
    mail to: @response.user.email, subject: @subject
  end
end
