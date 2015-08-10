class Request < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message, class_name: "SMS"

  has_many :orders
  has_many :supplies, through: :orders
  accepts_nested_attributes_for :orders, allow_destroy: false

  def self.due_date created_at
    created_at.at_beginning_of_month.next_month.strftime "%B %d"
  end
end
