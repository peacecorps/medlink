class Phone < ActiveRecord::Base
  belongs_to :user

  before_save { |rec| rec.condensed = Phone.condense rec.number }

  include Concerns::Immutable
  immutable :number, :condensed
  validates :condensed, uniqueness: { scope: :user_id }, on: :create

  def has_country_code
    unless number.start_with? '+'
      @errors.add :number, "should include a country code (e.g. +1 for the US)"
    end
  end
  validate :has_country_code

  def self.condense number
    number.gsub /[^+\d]/, ''
  end

  def self.lookup number
    where(condensed: condense(number)).first
  end
end
