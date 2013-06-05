class UserMailer < ActionMailer::Base
  default from: "no-reply@pcmedsupply.com"

  def forgotten_password id
    User.find(id).send_reset_password_instructions async: false
  end

  def fulfillment id
    @order = Order.find id
    mail to: @order.email, subject: "Your Order Has Been Fufilled"
  end
end
