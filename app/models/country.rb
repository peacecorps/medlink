class Country < ActiveRecord::Base
  has_many :users

  def self.with_orders
    # FIXME: have orders store a reference to country for more efficient query here
    ids = Order.joins(:user => :country).uniq.pluck :country_id
    find ids
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end

  def to_s
    name
  end
end
