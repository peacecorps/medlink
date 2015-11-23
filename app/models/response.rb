class Response < ActiveRecord::Base
  MAX_LENGTH = 160

  include Concerns::UserScope

  belongs_to :message
  belongs_to :replacement, class_name: "Request"

  has_many :orders
  has_many :supplies, through: :orders

  belongs_to :received_by, class_name: "User", foreign_key: "received_by"
  has_many :receipt_reminders

  validates :extra_text, length: { maximum: MAX_LENGTH }

  def set_text text
    self.extra_text = text.slice(0, MAX_LENGTH)
  end

  def mark_updated_orders!
    supply_ids = supplies.pluck :id
    user.orders.where(supply_id: supply_ids, delivery_method: nil).each do |o|
      o.update_attributes response_id: id
    end
  end

  def auto_archivable?
    orders.all? { |o| o.delivery_method && o.delivery_method.auto_archive? }
  end

  def cancel!
    update! cancelled_at: Time.now
  end

  def received?
    received_at.present?
  end

  def cancelled?
    cancelled_at.present?
  end

  def archived?
    received? || cancelled?
  end

  def reordered?
    replacement_id.present?
  end

  def reordered_at
    replacement.try :created_at
  end
end
