require "rails_helper"

RSpec.describe UserMailer do
  Given(:response) { FactoryGirl.create :response, id: 10, delivery_count: 2, extra_text: "Please note something" }

  When        { UserMailer.fulfillment(response).deliver_now }
  When(:mail) { ActionMailer::Base.deliveries.last           }

  Then { mail.to = [response.user.email]                       }
  And  { mail.subject.include? "Your order has been processed" }
  And  { mail.to_s.include? "Please note something"            }
  And  { mail.to_s.include? response.supplies.first.name       }
end
