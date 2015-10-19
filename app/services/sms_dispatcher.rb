class SMSDispatcher < SMSResponder
  attr_reader :account_sid, :from, :to, :body

  def initialize account_sid:, from:, to:, body:
    @account_sid, @from, @to, @body = account_sid, from, to, body
  end

  def valid_sid?
    twilio.present?
  end

  def record_and_respond
    record_receipt

    unless user
      error! "sms.unrecognized_user"
    end

    if body.empty?
      error! "sms.unparseable"
    end

    handler.respond
  rescue PresentableError => e
    send_response e.message
  end

private

  def record_receipt
    @sms = SMS.create! \
      user:           user,
      twilio_account: twilio,
      number:         from,
      text:           body,
      direction:      :incoming
  end

  def twilio
    @_twilio ||= TwilioAccount.where(sid: account_sid, number: to).first
  end

  def user
    @_user ||= if pcv_id_override
      User.find_by_pcv_id pcv_id_override
    else
      User.find_by_phone_number from
    end
  end

  def pcv_id_override
    body =~ /^@(\w+)/ && $1
  end

  def handler
    [ SMSReceiptRecorder, SMSOrderPlacer ].each do |klass|
      h = klass.new twilio: twilio, sms: sms
      return h if h.valid? # Note: SMSOrderPlacer is always valid
    end
  end
end
