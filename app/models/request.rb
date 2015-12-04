class Request < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message, class_name: "SMS"
  belongs_to :submitter, foreign_key: "entered_by", class_name: "User"

  has_many :orders
  has_many :supplies, through: :orders

  belongs_to :reorder_of, class_name: "Response"
end
