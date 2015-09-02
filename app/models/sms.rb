class SMS < ActiveRecord::Base
  MAX_LENGTH = 160

  self.table_name = "messages"

  enum direction: [ :incoming, :outgoing ]

  belongs_to :user
  belongs_to :twilio_account
  has_one :request, foreign_key: :message_id

  validates_presence_of :twilio_account, :number, :direction

  include Concerns::Immutable
  immutable :user_id, :twilio_account_id, :number, :direction, :text

  def self.newest
    order(created_at: :desc).first
  end

  def duplicate within:
    SMS.incoming.
      where(text: text, number: number).
      where(["created_at >= ?", within.ago]).
      where.not(id: id).
      order(created_at: :desc).
      first
  end
end
