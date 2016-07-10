module FeatureHelpers
  def screenshot path=nil
    path ||= "#{ENV['HOME']}/Desktop/screenshot.png"
    page.save_screenshot path, full: true
  end

  def logout
    page.driver.browser.clear_cookies
  end

  def login_as user
    logout
    visit root_path
    within ".sign-in" do
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_on "Sign In"
    end
  end

  def flash
    page.find ".flash"
  end

  def main_body
    page.find ".main_body"
  end

  def s
    save_and_open_page
  end
end

module SMSHelpers
  def as user
    @sender  = user
    @phone   = @sender.phones.first || FactoryGirl.create(:phone, user: @sender)
    @country = @sender.country
    @twilio  = @country.twilio_account
    @sender
  end

  def see matcher
    @seen = if @seen
      SMS.outgoing.where("id > ?", @seen.id).last
    else
      SMS.outgoing.last
    end

    if matcher.nil?
      expect(@seen).to be_nil
    else
      expect(@seen).to be_present
      expect(@seen.number).to eq @phone.condensed
      expect(@seen.text.length).to be < 160
      expect(@seen.text).to match matcher
    end
  end

  def send msg
    Medlink.slackbot.requests.clear
    Medlink.pingbot.requests.clear

    dispatcher = SMS::Receiver.new sid: @twilio.sid, to: @twilio.number
    dispatcher.handle from: @phone.number, body: msg
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
  config.include SMSHelpers,     type: :sms
end
