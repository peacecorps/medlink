class CountrySMSJob < ApplicationJob
  def perform country, message
    users = country.textable_pcvs
    Slackbot.new.message "Sending #{message} to #{users.count} users in #{country.name}"
    users.each do |user|
      begin
        user.send_text message
      rescue StandardError => e
        Slackbot.new.message "Could not send to #{user} - #{e} (#{self})"
      end
    end
  end
end
