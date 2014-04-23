module Concerns::UserScope
  extend ActiveSupport::Concern

  included do
    belongs_to :user
    validates_presence_of :user

    belongs_to :country
    def country_id
      super || user.country_id
    end
    before_save { self.country = user.country }
  end
end
