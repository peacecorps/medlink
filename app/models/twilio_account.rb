class TwilioAccount < ActiveRecord::Base
  has_many :messages, class_name: "SMS"

  validates :sid, presence: true, uniqueness: true

  def send_text to, text
    phone = Phone.for number: to
    UserTexter.new(phone: phone, twilio_account: self).send text
  end

  # We may pull down production data with live credentials, but want to make sure we
  #  don't inadvertently send texts.
  if Rails.configuration.send_texts
    def client
      @_client ||= Twilio::REST::Client.new(sid, auth)
    end
  else
    def client
      @_client ||= Twilio::REST::Client.new(
        Figaro.env.twilio_test_sid!, Figaro.env.twilio_test_auth!)
    end
    def number
      "+15005550006" # Twilio's valid test number
    end
  end
end
