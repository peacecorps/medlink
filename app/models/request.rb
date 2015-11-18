class Request < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message, class_name: "SMS"

  has_many :orders
  has_many :supplies, through: :orders
  accepts_nested_attributes_for :orders, allow_destroy: false

  belongs_to :reorder_of, class_name: "Response"
end
