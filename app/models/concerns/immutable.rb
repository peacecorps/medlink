module Concerns::Immutable
  extend ActiveSupport::Concern

  module ClassMethods
    def immutable_fields
      @_immutable_fields ||= []
    end

    def immutable *fields
      immutable_fields.push *fields
    end
  end

  def check_immutable_fields
    disallowed = changes.keys.map(&:to_sym) & self.class.immutable_fields
    disallowed.each do |field|
      errors.add(field, "is immutable")
    end
  end

  included do
    validate :check_immutable_fields, on: :update
  end
end
