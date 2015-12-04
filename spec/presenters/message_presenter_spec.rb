require "rails_helper"

RSpec.describe MessagePresenter do
  Given(:message) { FactoryGirl.build :sms, created_at: DateTime.new(1990, 06, 12, 12, 34) }

  When(:result) { MessagePresenter.new message }

  Then { result.created_at == "June 12, 1990 @08:34"                    }
  And  { result.user_link.include? "/users/#{message.user_id}/timeline" }
  And  { result.email.include? "mailto:#{message.user.email}"           }
  And  { result.number.include? "tel:#{message.phone.condensed}"        }
  And  { result.country == message.user.country.name                    }
end
