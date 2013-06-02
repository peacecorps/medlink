class Supply < ActiveRecord::Base
  attr_accessible :name, :shortcode

  has_many :requests
  has_many :users, through: :requests

  def self.lookup str
    where(['lower(shortcode) = ?', str.downcase]).first || 
    where(['lower(name) = ?',      str.downcase]).first
  end
end
