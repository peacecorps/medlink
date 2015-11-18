class CountrySMSJob < ApplicationJob
  def perform country, message
    users = country.textable_pcvs
    Rails.configuration.slackbot.info "Sending #{message} to #{users.count} users in #{country.name}"
    users.each do |user|
      begin
        user.send_text message
      rescue StandardError => e
        Rails.configuration.slackbot.error "Could not send to #{user} - #{e} (#{self})"
      end
    end
  end
end
