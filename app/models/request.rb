class Request < ActiveRecord::Base
  belongs_to :order
  belongs_to :supply

  validates_presence_of :supply, message: "Invalid shortcode"
end
