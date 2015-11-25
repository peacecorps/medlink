class Order < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :supply
  belongs_to :request
  belongs_to :response

  validates_presence_of :supply, :request, on: :create
  immutable :supply_id, :request_id

  serialize :delivery_method, DeliveryMethod

  paginates_per 10
  default_scope { order created_at: :desc }

  scope :with_responses, -> { where.not response_id: nil }
  scope :without_responses, -> { where response_id: nil }

  def due_at
    created_at.at_end_of_month + 3.days
  end

  def responded_at
    response && response.created_at
  end

  def delivery_method= method
    m = DeliveryMethod.load method
    raise "Could not coerce '#{method}' to a delivery method" if method && !m
    super m
  end

  def denied?
    delivery_method == DeliveryMethod::Denial
  end

  def duplicated?
    duplicated_at.present?
  end
end
