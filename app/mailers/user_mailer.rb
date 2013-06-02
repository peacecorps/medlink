class UserMailer < ActionMailer::Base
  default from: "no-reply@pcmedsupply.com"

  def welcome_email(user)
    @user = user
    @url = "http://pcmedsupply.com/users/sign_in"
    mail(:to => user.email, :subject => "Thanks for signing up for pcmedsupply.org")
  end

  def forgotten_password_email(params)
    User.send_reset_password_instructions(email: params[:email])
  end

  def fulfillment_email(order)
    @order = order
    mail(:to => order.email, :subject => "Your Order Has Been Fufilled")
  end
end
