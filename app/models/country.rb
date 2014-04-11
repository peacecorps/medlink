class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses

  def self.with_orders
    find Order.uniq.pluck(:country_id)
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end
end
