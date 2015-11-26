class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders
  has_many :country_supplies
  has_many :countries, through: :country_supplies

  before_save { self.shortcode = shortcode.upcase }

  default_scope { where(orderable: true).order name: :asc }

  validates :shortcode, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def self.find_by_shortcode code
    where(shortcode: code.upcase).first!
  end

  def select_display
    "#{name} (#{shortcode})"
  end
end
