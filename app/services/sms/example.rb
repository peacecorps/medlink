class SMS::Example < SMS::Handler
  def valid?
    sms.text.strip =~ /"?example"?/i
  end

  def run!
    aceta = Supply.find_by shortcode: "ACETA"
    malmd = Supply.find_by shortcode: "MALMD"
    %|To order #{aceta.name} and #{malmd.name} with a custom message, you would say "#{aceta.shortcode}, #{malmd.shortcode} - your message"|
  end
end
