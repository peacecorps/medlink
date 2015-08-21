class CountrySMSJob < ActiveJob::Base
  def perform country, message
    country.users.includes(:phones).each do |user|
      user.send_text message
    end
  end
end
