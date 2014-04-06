class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses

  def self.with_orders
    # TODO: unique in DB
    find Order.pluck(:country_id).uniq
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end
end
