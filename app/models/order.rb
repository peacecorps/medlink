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

  def self.due_cutoff
    now = Time.now
    oldest = now.at_beginning_of_month
    now.day < 3 ? oldest - 1.month : oldest
  end

  scope :past_due, -> { without_responses.where ["orders.created_at < ?", due_cutoff]  }
  scope :pending,  -> { without_responses.where ["orders.created_at >= ?", due_cutoff] }

  def response_time
    #FIXME: Absolute delta response time or remove weekends
    response && ((response.created_at - created_at) / (60 * 60 * 24)).round(1)
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
