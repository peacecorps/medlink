module MailHelpers
  def slackbot
    Rails.configuration.slackbot
  end

  def pingbot
    Rails.configuration.pingbot
  end

  def mail
    ActionMailer::Base.deliveries
  end
end

RSpec.configure do |config|
  config.include MailHelpers
  config.before :each do
    ActionMailer::Base.deliveries = []
  end
end
