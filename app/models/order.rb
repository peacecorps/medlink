class Order < ActiveRecord::Base
  belongs_to :country
  belongs_to :user
  belongs_to :supply
  belongs_to :response

  validates_presence_of :user
  validates_presence_of :supply

  before_save { self.country = user.country }

  serialize :delivery_method, DeliveryMethod

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

  def responded?
    response_id.present?
  end

  def responded_at
    response && response.created_at
  end

  def denied?
    delivery_method == DeliveryMethod::Denial
  end
end
