class UserMailer < ActionMailer::Base
  default from: "no-reply@pcmedsupply.com"

  def welcome id
    @user = User.find id
    @url = "http://pcmedsupply.com/users/sign_in"
    mail to: @user.email, subject: "Thanks for signing up for pcmedsupply.org"
  end

  def forgotten_password id
    User.find(id).send_reset_password_instructions async: false
  end

  def fulfillment id
    @order = Order.find id
    mail to: @order.email, subject: "Your Order Has Been Fufilled"
  end
end
