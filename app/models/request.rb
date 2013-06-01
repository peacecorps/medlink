class Request < ActiveRecord::Base
  attr_accessible :dose, :quantity, :supply_id
  attr_accessible :phone, :email

  belongs_to :order
  belongs_to :supply

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
