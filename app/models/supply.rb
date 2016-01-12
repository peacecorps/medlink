class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders
  has_many :country_supplies
  has_many :countries, through: :country_supplies

  before_create { self.shortcode = shortcode.upcase }

  default_scope { order name: :asc }
  scope :globally_available, -> { where orderable: true }

  validates :shortcode, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  def select_display
    "#{name} (#{shortcode})"
  end
end
