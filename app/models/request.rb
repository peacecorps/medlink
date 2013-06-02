class Request < ActiveRecord::Base
  attr_accessible :dose, :quantity, :supply_id
  attr_accessible :phone, :email

  belongs_to :order
  belongs_to :supply

  validates_presence_of :supply, message: "Invalid shortcode"
end
