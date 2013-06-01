class Supply < ActiveRecord::Base
  attr_accessible :name, :shortcode

  has_many :requests
  has_many :users, through: :requests
end
