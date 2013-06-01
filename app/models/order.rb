class Order < ActiveRecord::Base
  attr_accessible :confirmed, :email, :extra, :fulfilled, :pc_hub_id, :phone, :user_id
end
