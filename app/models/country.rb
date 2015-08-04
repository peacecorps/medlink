class Country < ActiveRecord::Base
  has_many :users
  has_many :orders
  has_many :responses
  has_many :country_supplies
  has_many :supplies, through: :country_supplies

  belongs_to :twilio_account

  def self.with_orders
    ids = Order.unscoped.uniq.pluck :country_id
    find(ids).sort_by(&:name)
  end

  def self.choices
    all.map { |c| [c.name, c.id] }
  end

  def twilio_account
    if twilio_account_id
      TwilioAccount.find twilio_account_id
    else
      TwilioAccount.default
    end
  end
end
