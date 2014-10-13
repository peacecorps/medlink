class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses
  has_many :country_supplies
  has_many :supplies, :through => :country_supplies 

  def self.with_orders
    ids = Order.unscoped.uniq.pluck :country_id
    find ids
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end
end
