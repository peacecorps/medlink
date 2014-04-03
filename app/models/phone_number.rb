class PhoneNumber < ActiveRecord::Base
  belongs_to :user

  before_save { |rec| rec.condensed = PhoneNumber.condense rec.display }

  validates :condensed, uniqueness: { scope: :user_id }

  def self.condense number
    number.gsub /\D+/, ''
  end

  def self.lookup number
    where(condensed: condense(number)).first!
  end
end
