class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def forgotten_password id
    User.find(id).send_reset_password_instructions async: false
  end

  def fulfillment id
    @response = Response.find id
    @order = @response.order

    email = @order.email || @order.user.email
    @subject = if @response.denied?
      "Your Order Has Been Denied"
    else
      "Your Order Has Been Fulfilled"
    end
    mail to: email, subject: @subject
  end
end
