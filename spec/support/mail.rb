module MailHelpers
  def slackbot
    Medlink.slackbot
  end

  def pingbot
    Medlink.pingbot
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
