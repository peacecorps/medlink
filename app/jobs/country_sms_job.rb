class CountrySMSJob < ApplicationJob
  def perform country:, message:
    phones = country.users.pcv.includes(:phones).map { |u| u.primary_phone }.compact

    Rails.configuration.slackbot.info \
      "Sending #{message} to #{phones.count} users in #{country.name}"

    twilio = country.twilio_account
    phones.each do |phone|
      SmsJob.perform_later phone: phone, twilio_account: twilio, message: message
    end
    true
  end
end
