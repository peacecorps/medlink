class PhoneNumber < ActiveRecord::Base
  belongs_to :user

  before_save { |rec| rec.condensed = PhoneNumber.condense rec.display }

  validates :condensed, uniqueness: { scope: :user_id }

  def has_country_code
    unless self[:display].start_with? '+'
      # TODO: rename this field `number` so the validation makes sense
      #       and so we don't need that weird `display` overwrite
      @errors.add :display, "should include a country code"
    end
  end
  validate :has_country_code

  def self.condense number
    number.gsub /[^+\d]/, ''
  end

  def self.lookup number
    where(condensed: condense(number)).first!
  end

  def display
    self[:display] # Some sort of unfortunate name collision necessitates this
  end
end
