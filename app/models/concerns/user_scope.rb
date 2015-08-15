module Concerns::UserScope
  extend ActiveSupport::Concern

  def ensure_country_id
    errors.add(:country_id, "is not set") unless country_id == user.country_id
  end

  included do
    include Concerns::Immutable

    belongs_to :user
    belongs_to :country

    validates_presence_of :user, :country_id, on: :create
    validate :ensure_country_id, on: :create

    immutable :user, :country_id
  end
end
