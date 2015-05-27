class CountrySMSJob < ActiveJob::Base
  def perform country_id, message
    country = Country.find country_id
    country.users.includes(:phones, :country).each do |user|
      user.send_text message
    end
  end
end
