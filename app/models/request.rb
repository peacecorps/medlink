class Request < ActiveRecord::Base
  include Concerns::UserScope

  has_many :orders
  accepts_nested_attributes_for :orders, allow_destroy: false
end
