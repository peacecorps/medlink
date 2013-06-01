class Request < ActiveRecord::Base
  attr_accessible :dose, :location, :quantity, :state, :supply_id, :user_id
  attr_accessible :phone, :email

  belongs_to :user
  belongs_to :supply

  def confirm!
    update_attribute :confirmed, true
  end
end
