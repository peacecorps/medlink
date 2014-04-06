class Country < ActiveRecord::Base
  has_many :users

  def self.with_orders
    ids = Order.joins(user: :country).uniq.pluck :country_id
    find ids
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end

  def to_s
    name
  end
end
