class Order < ActiveRecord::Base
  attr_accessible :confirmed, :email, :extra, :fulfilled, :pc_hub_id, :phone, :user_id

  belongs_to :user
  has_many :requests

  HUMANIZED_ATTRIBUTES = {
    :user => "PCVID"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates :user_id, presence: true

  def self.create_from_text data
    user   = User.where(pcv_id: data[:pcvid]).first
    hub    = PcHub.where(name: data[:loc]).first
    supply = Supply.where(shortcode: data[:shortcode]).first

    order = new({
      user_id:   user.try(:id),
      pc_hub_id: hub.try(:id),
      phone:     data[:phone] || user.try(:phone),
      email:     data[:email] || user.try(:email)
    })

    if order.save
      order.requests.create({
        supply_id: supply.try(:id),
        dose:      "#{data[:dosage_value]}#{data[:dosage_units]}",
        quantity:  data[:qty]
      })
    end

    order
  end
end
