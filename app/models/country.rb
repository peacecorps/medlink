class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses
  has_many :country_supplies
  has_many :supplies, through: :country_supplies

  belongs_to :twilio_account

  validates_presence_of :name, :twilio_account
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }

  default_scope -> { order(name: :asc) }

  def self.with_orders
    ids = Order.unscoped.uniq.pluck :country_id
    where(id: ids)
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end

  def textable_pcvs
    @_textable_pcvs ||= users.pcv.includes(:phones).select(&:textable?)
  end
end
