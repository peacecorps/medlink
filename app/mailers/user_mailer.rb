class UserMailer < Devise::Mailer
  default from: "support@pcmedlink.org"

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
