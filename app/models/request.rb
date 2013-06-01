class Request < ActiveRecord::Base
  attr_accessible :dose, :location, :quantity, :state, :supply_id, :user_id

  belongs_to :user
  belongs_to :supply
end
