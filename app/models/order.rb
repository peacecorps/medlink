class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :supply
  belongs_to :response

  validates_presence_of :user
  validates_presence_of :supply

  scope :with_responses, -> { includes(:response).where("response_id IS NOT NULL") }
  scope :without_responses, -> { where("response_id IS NULL") }

  scope :past_due, -> { without_responses.where(["orders.created_at < ?",
    3.business_days.ago]) }
  scope :pending,  -> { without_responses.where(["orders.created_at >= ?",
    3.business_days.ago]) }

  def response_time
    #FIXME: Absolute delta response time or remove weekends
    response && ((response.created_at - created_at) / (60 * 60 * 24)).round(1)
  end

  def how_past_due
    # How many days over 3 are we past due?
    if response
      past_due = (
        (3.business_days.after(created_at) -
          response.created_at) / (60 * 60 * 24)
      ).round(1)
      if (past_due < 3)
        0
      else
        (past_due - 3).round(1)
      end
    end
  end

  def country_id
    # FIXME: make this an actual column
    user.country_id
  end

  def responded?
    response.present?
  end

  def responded_at
    response && response.created_at
  end

  def denied?
    delivery_method == DeliveryMethod::Denial
  end

  def fulfilled?
    fulfilled_at.present?
  end

  def self.human_attribute_name(attr, options={})
    {
      user:   "PCV ID",
      supply: "Supply"
    }[attr] || super
  end

  def confirmation_message
    if self.valid?
      I18n.t "order.confirmation"
    else
      errors.full_messages.join ","
    end
  end
end
