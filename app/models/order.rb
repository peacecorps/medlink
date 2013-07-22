class Order < ActiveRecord::Base
  belongs_to :user
  has_many :requests

  validates_presence_of :user,   message: "unrecognized"
  accepts_nested_attributes_for :requests

  scope :unfulfilled, -> { where(fulfilled: false) }

  def self.human_attribute_name(attr, options={})
    {
      user:   "PCV ID"
    }[attr] || super
  end

  def self.create_from_text data
    user   = User.lookup(data[:pcvid]) || raise("Unrecognized PCVID")
    supply = Supply.lookup data[:shortcode]

    create!({
      user_id:   user.try(:id),
      phone:     data[:phone],
      email:     user.try(:email),
      requests_attributes: [{
        supply_id: supply.try(:id),
        dose:      "#{data[:dosage_value]}#{data[:dosage_units]}",
        quantity:  data[:qty]
      }]
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
    to = self.phone || user.phone
    SMSJob.enqueue(to, instructions) if to
    MailerJob.enqueue :fulfillment, id
  end

  def dup_hash
    {
      user:     user.id,
      requests: requests.map { |r| [r.supply_id, r.dose, r.quantity]
        }.sort_by(&:first)
    }
  end

  def self.create! attrs={}
    # Prevent creating an order with identical user and requests
    if user = User.find(attrs[:user_id])
      dh   = new(attrs).dup_hash
      dups = user.orders.unfulfilled.select { |o| o.dup_hash == dh }
      raise "Cannot create duplicate order" unless dups.empty?
    end

    super
  end

  def supplies
    requests.includes(:supply).map { |r| r.supply.name }
  end
end
