require 'spec_helper'

describe SMSJob do
  include SmsSpec::Helpers

  it 'just sends a text message' do
    subject.perform '+12345678901', 'Test'
    open_last_text_message_for '+12345678901'
    current_text_message.should have_body 'Test'
  end
end