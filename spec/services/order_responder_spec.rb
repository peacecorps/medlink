require "rails_helper"

RSpec.describe OrderResponder, :queue_jobs do
  Given(:volunteer)  { create :pcv }
  Given(:supplies)   { Supply.random 3 }
  Given(:orders)     { supplies.map { |s| create(:order, supply: s, user: volunteer) } }
  Given(:order_ids)  { orders.map &:id }
  Given(:text)       { nil }
  Given(:response)   { Medlink.order_responder.build user_id: volunteer.id, text: text, selections: selection }

  Given(:reminders)  { queued PromptForReceiptAcknowledgementJob }
  Given(:timestamps) { reminders.map { |job| job[:at] } }
  Given(:future)     { (10.days.from_now.to_i .. 30.days.from_now.to_i) }

  When(:result) { Medlink.order_responder.save response }

  context "approval" do
    Given(:selection) { order_ids.zip(%i(delivery pickup delivery)).to_h }

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
    Given(:text)      { "N.B." }

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
    Given(:text)      { "No!!" }

    Then { result.user == volunteer                                      }
    And  { result.orders.count == 1                                      }
    And  { result.orders.first.delivery_method == DeliveryMethod::Denial }
    And  { result.archived_at.present?                                   }

    And  { reminders.count == 0                                  }
    And  { queued(ResponseSMSJob).count == 1                     }
    And  { queued(ActionMailer::DeliveryJob).count == 1          }
  end

  context "with duplicated orders" do
    Given!(:duplicated) { create :order,
      user: volunteer, supply: orders[0].supply, created_at: 2.months.ago }
    Given(:selection) { { orders[0].id => :delivery } }

    Then { result.orders.include? orders[0]  }
    And  { result.orders.include? duplicated }
  end

  context "with other orders pending" do
    Given(:oldest)      { create :order, user: volunteer, created_at: 1.month.ago }
    Given(:unobtainium) { create :supply }
    Given!(:older)      { create :order, user: volunteer, created_at: 2.weeks.ago, supply: unobtainium }
    Given(:selection)   { { oldest.id => :delivery } }

    Then { result.orders.include? oldest                              }
    And  { same_time volunteer.reload.waiting_since, older.created_at }
  end
end
