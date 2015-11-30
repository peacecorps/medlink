require 'rails_helper'

RSpec.describe RequestForm do
  Given(:pcv)        { FactoryGirl.create :pcv }
  Given(:pcmo)       { FactoryGirl.create :pcmo, country: pcv.country }
  Given(:supplies)   { pcv.country.supplies.order("random()").first 3 }
  Given(:supply_ids) { supplies.map &:id }

  context "request for multiple supplies" do
    Given(:form)  { RequestForm.new pcv.personal_requests.new }
    When(:result) { form.validate(supplies: supply_ids, text: "Please!") && form.save && form.model }

    Then { result.user == pcv                                 }
    And  { result.entered_by == pcv.id                        }
    And  { result.supplies.count == 3                         }
    And  { result.text == "Please!"                           }
    And  { result.persisted?                                  }
    And  { result.user.last_requested_at == result.created_at }
    And  { result.user.waiting_since     == result.created_at }

    And  { form.users.count == 1                                    }
    And  { form.success_message.include? "Your order has been sent" }
  end

  context "for a user" do
    Given(:form) { RequestForm.new pcmo.submitted_requests.new }

    When(:result) { form.validate(user: pcv.id, supplies: supply_ids) && form.save && form.model }

    Then { result.user == pcv           }
    And  { result.entered_by == pcmo.id }

    And  { form.success_message.include? "The order you placed on behalf of #{pcv.name}" }
  end

  context "without pcv" do
    Given(:form) { RequestForm.new pcmo.submitted_requests.new }

    When(:result) { form.validate supplies: supply_ids }

    Then { result == false            }
    And  { Request.count == 0         }
    And  { form.errors.include? :user }
  end

  context "without supplies" do
    Given(:form) { RequestForm.new pcv.personal_requests.new }

    When(:result) { form.validate supplies: [] }

    Then { result == false                }
    And  { Request.count == 0             }
    And  { form.errors.include? :supplies }
  end

  context "with non-offered supply" do
    Given(:supply) { FactoryGirl.create :supply }
    Given(:form)   { RequestForm.new pcv.personal_requests.new }

    When(:result) { form.validate supplies: [supply.id] }

    Then { result == false                }
    And  { Request.count == 0             }
    And  { form.errors.include? :supplies }
  end

  context "with duplicated orders" do
    Given(:old)  { RequestForm.new pcv.personal_requests.new }
    Given(:form) { RequestForm.new pcv.personal_requests.new }

    When          { old.validate(supplies: supply_ids.sample(2)) && old.save }
    When(:result) { form.validate(supplies: supply_ids) && form.save && form.model }

    Then { same_time result.user.last_requested_at, result.created_at }
    And  { same_time result.user.waiting_since, old.model.created_at  }
    And  { result.created_at != old.model.created_at                  }
    And  { old.model.orders.all? { |o| o.duplicated_at }              }
  end
end
