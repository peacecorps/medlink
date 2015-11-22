require "rails_helper"

describe SMS::Dispatcher do
  Given(:twilio)   { TwilioAccount.first! }
  Given(:dispatch) { SMS::Dispatcher.new twilio: twilio }
end
