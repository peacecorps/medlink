class Request < ActiveRecord::Base
  attr_accessible :dose, :location, :quantity, :state, :supply_id, :user_id
  attr_accessible :phone, :email

  belongs_to :order
  belongs_to :supply

  HUMANIZED_ATTRIBUTES = {
    :user => "PCVID"
  }

  def self.human_attribute_name(attr, options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates_presence_of :supply, :message => "shortcode invalid."

  def confirm!
    update_attribute :confirmed, true
  end

  def confirmation_message
    if self.valid?
      return "Your request has been processed and action will be taken within 24 hours."
    else
      return errors.each_full.join(" ")
    end
  end
end
