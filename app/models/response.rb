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

  def reorders
    Request.where user: user, country: country, reorder_of_id: id
  end
end
