require "rails_helper"

RSpec.describe MessagePresenter do
  Given(:created) { DateTime.new(1990, 06, 12, 12, 34).utc      }
  Given(:message) { FactoryGirl.build :sms, created_at: created }
  Given(:tz)      { message.user.time_zone                      }

  When(:result) { MessagePresenter.new message }

  Then { result.created_at == created.in_time_zone(tz).strftime("%B %d, %Y @%H:%M") }
  And  { result.user_link.include? "/users/#{message.user_id}/timeline"             }
  And  { result.email.include? "mailto:#{message.user.email}"                       }
  And  { result.number.include? "tel:#{message.phone.condensed}"                    }
  And  { result.country == message.user.country.name                                }
end
