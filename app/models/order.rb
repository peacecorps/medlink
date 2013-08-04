class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :supply
  has_many :requests

  validates_presence_of :user,   message: "unrecognized"
  validates_presence_of :supply, message: "unrecognized"

  scope :unfulfilled, -> { where(fulfilled_at: nil) }

  def fulfilled?
    !fulfilled_at.nil?
  end

  validates_uniqueness_of :supply_id, conditions: -> { unfulfilled }

  def self.human_attribute_name(attr, options={})
    {
      user:   "PCV ID",
      supply: "shortcode"
    }[attr] || super
  end

  def self.create_from_text data
    user   = User.lookup   data[:pcvid]
    supply = Supply.lookup data[:shortcode]

    create!({
      user_id:   user.try(:id),
      phone:     data[:phone],
      email:     user.try(:email),
      supply_id: supply.try(:id),
      dose:      "#{data[:dosage_value]}#{data[:dosage_units]}",
      quantity:  data[:qty]
    })
  end

  def confirmation_message
    if self.valid?
      I18n.t "order.confirmation"
    else
      errors.full_messages.join ","
    end
  end

  def send_instructions!
    # FIX
    to = self.phone || user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end

  def full_dosage
    "#{dose}#{unit}"
  end

  # FIXME: store fulfillment action along with message
  def action
  end
end
