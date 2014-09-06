class Supply < ActiveRecord::Base
  has_many :orders
  has_many :users, through: :orders
  has_many :country_supplies
  has_many :countries, through: :country_supplies

  before_save { self.shortcode = shortcode.upcase }

  def self.choices
    all.map { |supply| [supply.name, supply.id] }
  end

  def self.find_by_shortcode code
    where(shortcode: code.upcase).first!
  end

  def self.find_by_shortcodes codes
    upcodes = codes.map &:upcase
    found = where shortcode: upcodes
    missed = upcodes - found.map(&:shortcode)
    if missed.any?
      raise SMS::FriendlyError.new "sms.unrecognized_shortcodes",
        { codes: missed }, condense: :code
    end
    found
  end
end
