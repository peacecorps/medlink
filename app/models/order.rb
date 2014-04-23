class Order < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :supply
  belongs_to :request
  belongs_to :response

  validates_presence_of :supply, :request

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

  include ActionView::Helpers::DateHelper

  def due_at
    created_at.at_end_of_month + 3.days
  end

  def how_past_due
    finish = responded_at || Time.now
    return unless finish > due_at
    distance_of_time_in_words finish, due_at
  end

  def response_time
    return unless responded?
    distance_of_time_in_words response.created_at, created_at
  end

  def responded?
    response_id.present?
  end

  def responded_at
    response && response.created_at
  end

  def delivery_method= method
    method = DeliveryMethod.find { |m| m.name.to_s == method } unless method.is_a? DeliveryMethod
    super method
  end

  def denied?
    delivery_method == DeliveryMethod::Denial
  end
end
