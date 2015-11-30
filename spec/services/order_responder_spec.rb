require "rails_helper"

RSpec.describe OrderResponder, :queue_jobs do
  Given(:volunteer)  { FactoryGirl.create :pcv }
  Given(:supplies)   { Supply.random 3 }
  Given(:orders)     { supplies.map { |s| FactoryGirl.create(:order, supply: s, user: volunteer) } }
  Given(:order_ids)  { orders.map &:id }
  Given(:responder)  { OrderResponder.new(volunteer.responses.new) }

  Given(:reminders)  { queued PromptForReceiptAcknowledgementJob }
  Given(:timestamps) { reminders.map { |job| job[:at] } }
  Given(:future)     { (10.days.from_now.to_i .. 30.days.from_now.to_i) }

  context "approval" do
    Given(:selection) { order_ids.zip %i(delivery pickup delivery) }

    When(:result) { responder.run selections: selection }

    Then { result.user == volunteer                              }
    And  { result.extra_text == nil                              }
    And  { result.orders.count == 3                              }
    And  { result.orders.all? { |o| o.delivery_method.present? } }
    And  { !result.archived?                                     }

    And  { reminders.count == 4                                  }
    And  { timestamps.all? { |t| future.cover? t }               }
    And  { queued(ResponseSMSJob).count == 1                     }
    And  { queued(ActionMailer::DeliveryJob).count == 1          }
  end

  context "partial approval" do
    Given(:selection) { { order_ids[0] => :delivery, order_ids[2] => :denial } }

    When(:result) { responder.run text: "N.B.", selections: selection }

    Then { result.user == volunteer                              }
    And  { result.extra_text == "N.B."                           }
    And  { result.orders.count == 2                              }
    And  { !result.orders.include? order_ids[1]                  }
    And  { result.orders.all? { |o| o.delivery_method.present? } }
    And  { !result.archived?                                     }

    And  { reminders.count == 4                                  }
    And  { timestamps.all? { |t| future.cover? t }               }
    And  { queued(ResponseSMSJob).count == 1                     }
    And  { queued(ActionMailer::DeliveryJob).count == 1          }
  end

  context "denial" do
    Given(:selection) { { order_ids[1] => :denial } }

    When(:result) { responder.run text: "No!!", selections: selection }

    Then { result.user == volunteer                                      }
    And  { result.orders.count == 1                                      }
    And  { result.orders.first.delivery_method == DeliveryMethod::Denial }
    And  { result.archived_at.present?                                   }

    And  { reminders.count == 0                                  }
    And  { queued(ResponseSMSJob).count == 1                     }
    And  { queued(ActionMailer::DeliveryJob).count == 1          }
  end

  context "with duplicated orders" do
    Given!(:duplicated) { FactoryGirl.create :order,
      user: volunteer, supply: orders[0].supply, created_at: 2.months.ago }
    Given(:selections) { { orders[0].id => :delivery } }

    When(:result) { responder.run selections: selections }

    Then { result.orders.include? orders[0]  }
    And  { result.orders.include? duplicated }
  end

  context "with other orders pending" do
    Given(:oldest)      { FactoryGirl.create :order, user: volunteer, created_at: 1.month.ago }
    Given(:unobtainium) { FactoryGirl.create :supply }
    Given!(:older)      { FactoryGirl.create :order, user: volunteer, created_at: 2.weeks.ago, supply: unobtainium }

    When(:result) { responder.run selections: { oldest.id => :delivery } }

    Then { result.orders.include? oldest                              }
    And  { same_time volunteer.reload.waiting_since, older.created_at }
  end
end
