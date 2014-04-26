class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def forgotten_password id
    User.find(id).send_reset_password_instructions true
  end

  def fulfillment id
    @response = Response.find id
    @orders   = @response.orders.includes(:supply).reject &:duplicated_at
    @subject  = "Your order has been processed"
    mail to: @response.user.email, subject: "[PC Medlink] #{@subject}"
  end
end
