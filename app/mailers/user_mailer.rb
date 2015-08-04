class UserMailer < ActionMailer::Base
  default from: "support@pcmedlink.org"

  def welcome user
    @user       = user
    @token, enc = Devise.token_generator.generate User, :reset_password_token

    @user.reset_password_token   = enc
    @user.reset_password_sent_at = Time.now.utc
    @user.save validate: false

    mail to: @user.email, subject: "Welcome to PC Medlink"
  end

  def fulfillment response
    @response = response
    @orders   = @response.orders.includes(:supply).reject &:duplicated_at
    @subject  = "Your order has been processed"
    mail to: @response.user.email, subject: "[PC Medlink] #{@subject}"
  end

  private

  def style *args
    styles = args.reduce({}) do |acc,s|
      acc.merge(s.is_a?(Hash) ? s : send(s))
    end
    { style: styles.map { |k,v| "#{k}: #{v}" }.join("; ") }
  end
  helper_method :style

  def header
    { color: "#29a9df" }
  end

  def center
    { "text-align" => "center" }
  end
end
