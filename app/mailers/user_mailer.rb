class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def forgotten_password id
    User.find(id).send_reset_password_instructions true
  end

  def welcome id
    @user       = User.find id
    @token, enc = Devise.token_generator.generate User, :reset_password_token

    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save validate: false

    mail to: @user.email, subjec: "Welcome to PC Medlink"
  end

  def fulfillment id
    @response = Response.find id
    @orders   = @response.orders.includes(:supply).reject &:duplicated_at
    @subject  = "Your order has been processed"
    mail to: @response.user.email, subject: "[PC Medlink] #{@subject}"
  end
end
