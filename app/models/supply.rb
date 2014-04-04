class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders

  def to_s
    name
  end

  def self.choices
    all.map { |supply| [supply.name, supply.id] }
  end
end
