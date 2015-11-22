class SMS::SupplyList < SMS::Handler
  def valid?
    sms.text == "list supplies"
  end
end
