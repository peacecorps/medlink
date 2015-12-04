require "rails_helper"

RSpec.describe OrderResponsePresenter do
  Given(:response) { FactoryGirl.create :response }

  context "old order" do
    Given(:order) { FactoryGirl.build :order, response: response, created_at: 2.years.ago, delivery_method: :denial }

    When(:result) { OrderResponsePresenter.new order }

    Then { result.how_past_due == "almost 2 years"                    }
    And  { result.response_time == "about 2 years"                    }
    And  { !result.duplicated?                                        }
    And  { result.denied?                                             }
    And  { result.name_with_status == "#{order.supply.name} (Denial)" }
  end

  context "new order" do
    Given(:order) { FactoryGirl.build :order, response: response, created_at: 1.day.ago, delivery_method: :delivery, duplicated_at: 2.hours.ago }

    When(:result) { OrderResponsePresenter.new order }

    Then { result.how_past_due == nil      }
    And  { result.response_time == "1 day" }
    And  { result.status == "Duplicated"   }
  end
end
