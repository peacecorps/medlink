require "rails_helper"

RSpec.describe ResponseSMSJob do
  Given(:textable) { FactoryGirl.create :user, phone_count: 1 }

  context "with no phone" do
    Given(:response) { FactoryGirl.create :response, order_count: 2 }

    When(:result) { ResponseSMSJob.new.perform response }

    Then { result == false     }
    And  { SMS.outgoing.empty? }
  end

  context "with a phone" do
    Given(:response) { FactoryGirl.create :response, user: textable, order_count: 2 }

    When(:result) { ResponseSMSJob.new.perform response }

    Then { result == true                                                                     }
    And  { SMS.outgoing.exists?                                                               }
    And  { SMS.outgoing.last.user == response.user                                            }
    And  { response.supplies.pluck(:shortcode).any? { |c| SMS.outgoing.last.text.include? c } }
  end
end
