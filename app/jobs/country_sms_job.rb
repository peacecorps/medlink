class CountrySMSJob < ApplicationJob
  def perform country:, message:
    phones = country.users.pcv.includes(:phones).map { |u| u.primary_phone }.compact

    Medlink.notify Notification::SendingCountrySMS.new country: country, message: message, count: phones.count

    twilio = country.twilio_account
    phones.each do |phone|
      SmsJob.perform_later phone: phone, twilio_account: twilio, message: message
    end
    true
  end
end
