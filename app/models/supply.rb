class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders
  has_many :country_supplies
  has_many :countries, through: :country_supplies

  before_save { self.shortcode = shortcode.upcase }

  default_scope { order name: :asc }

  validates :shortcode, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def select_display
    "#{name} (#{shortcode})"
  end
end
