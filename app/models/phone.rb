class Phone < ActiveRecord::Base
  belongs_to :user
  has_many :messages, class_name: "SMS"

  before_validation on: :create do |p|
    p.condensed ||= Phone.condense(p.number)
  end

  include Concerns::Immutable
  validates :condensed, presence: true, uniqueness: true
  immutable :number, :condensed

  def has_country_code
    unless number.start_with? '+'
      @errors.add :number, "should include a country code (e.g. +1 for the US)"
    end
  end
  validate :has_country_code

  def self.condense number
    number.gsub(/[^+\d]/, '')
  end

  def self.for number:
    normalized = condense number
    normalized = "+#{normalized}" unless normalized.start_with? "+"
    if found = Phone.find_by_condensed(normalized)
      found
    else
      Phone.create! number: number, condensed: normalized
    end
  end
end
