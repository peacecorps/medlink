class Country < ActiveRecord::Base
  has_many :users

  def self.choices
    all.map { |c| [c.name, c.id] }
  end

  def to_s
    name
  end
end
