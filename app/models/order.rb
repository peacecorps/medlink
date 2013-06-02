class Order < ActiveRecord::Base
  attr_accessible :confirmed, :email, :extra, :fulfilled, :pc_hub_id, :phone, :user_id

  belongs_to :user
  belongs_to :pc_hub
  has_many :requests

  validates_presence_of :user,   message: "unrecognized"
  validates_presence_of :pc_hub, message: "unrecognized"

  def self.human_attribute_name(attr, options={})
    { 
      user:   "PCV ID",
      pc_hub: "Location code"
    }[attr] || super
  end

  def self.create_from_text data
    user   = User.where(pcv_id: data[:pcvid]).first || raise("Unrecognized PCVID")
    hub    = PcHub.where(name: data[:loc]).first || raise("Unrecognized location")
    supply = Supply.where(shortcode: data[:shortcode]).first || raise("Unrecognized shortcode")

    order = create!({
      user_id:   user.try(:id),
      pc_hub_id: hub.try(:id),
      phone:     data[:phone] || user.try(:phone),
      email:     data[:email] || user.try(:email)
    })
    
    begin
      order.requests.create!({
        supply_id: supply.try(:id),
        dose:      "#{data[:dosage_value]}#{data[:dosage_units]}",
        quantity:  data[:qty]
      })
    rescue ActiveRecord::RecordNotValid => e
      order.destroy
      raise
    end

    order
  end

  def confirmation_message
    if self.valid?
      "Your request has been processed and action will be taken within 24 hours."
    else
      errors.full_messages.join ","
    end
  end
end
