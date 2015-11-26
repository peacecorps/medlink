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

  def self.with_orders
    ids = Order.unscoped.uniq.pluck :country_id
    where(id: ids)
  end

  def textable_pcvs
    @_textable_pcvs ||= users.pcv.includes(:phones).select(&:textable?)
  end
end
