require "rails_helper"

RSpec.describe "error feedback", type: :sms do
  before(:each) {
    Medlink.slackbot.requests.clear
    Medlink.redis { |r| r.flushall }
  }

  it "informs people that it is a bot" do
    pcv = as create :pcv
    send "Hello! I need something."
    see  /^Unrecognized supply short codes: HELLO/
    send "I don't follow."
    see  %|Sorry, but I'm just a robot, and I don't know what you're saying. You can say "example" for an example of what I can understand, or "help" to page a human.|
    send "example"
    see  %|To order Acetaminophen and Malaria Medication with a custom message, you would say "ACETA, MALMD - your message"|
    expect(Medlink.slackbot.messages).to be_empty

    send '"help"'
    see  %|Okay, I've paged a human who will get in touch with you as soon as possible.|
    expect(Medlink.slackbot.messages.last).to match /It looks like.*#{pcv.email}.*is having trouble/
  end

  it "handles stubborn people" do
    pcv = as create :pcv
    send "yo"
    send "what"
    see  /^Sorry, but I\'m just a robot/
    send "what??!"
    see  "I still don't understand what you're saying, but I've paged a human who will get in touch with you as soon as possible."
    expect(Medlink.slackbot.messages.last).to match /It looks like.*#{pcv.email}.*is having trouble/

    send "something else"
    see  nil

    Timecop.travel Time.now + 5.minutes
    send "ABAND, ACETA"
    see  /^Thanks! Your request for/
  end
end
