class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def forgotten_password id
    User.find(id).send_reset_password_instructions async: false
  end

  def fulfillment id
    @response = Response.find id
    @order = @response.order
    email = @order.email || @order.user.email
    mail to: email, subject: "Your Order Has Been Fufilled"
  end
end
