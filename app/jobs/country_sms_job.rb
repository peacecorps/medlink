class CountrySMSJob < ApplicationJob
  def perform country, message
    users = country.textable_pcvs
    Slackbot.new.message "Sending #{message} to #{users.count} users in #{country.name}"
    users.each do |user|
      user.send_text message
    end
  end
end
