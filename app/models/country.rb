class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses
  has_many :country_supplies
  has_many :supplies, through: :country_supplies
  has_many :roster_uploads

  belongs_to :twilio_account

  validates_presence_of :name, :twilio_account

  default_scope -> { order(name: :asc) }

  def self.time_zones
    ActiveSupport::TimeZone.all
  end
  validates :time_zone, inclusion: { in: time_zones.map(&:name) }

  def toggle_supply supply
    join = country_supplies.where(supply_id: supply.id)
    if join.exists?
      join.delete_all
    else
      join.create!
    end
  end

  def available_supplies
    supplies.where orderable: true
  end
end
