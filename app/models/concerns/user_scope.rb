module Concerns::UserScope
  extend ActiveSupport::Concern

  included do
    include Concerns::Immutable

    belongs_to :user
    belongs_to :country

    validates_presence_of :user, on: :create
    before_create do
      self.country_id ||= user.country_id
    end

    immutable :user_id, :country_id
  end
end
