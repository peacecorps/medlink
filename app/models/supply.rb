class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders

  def self.choices
    all.map { |supply| [supply.name, supply.id] }
  end

  def self.find_by_shortcode code
    where(['lower(shortcode) = ?', code.downcase]).first!
  end
end
