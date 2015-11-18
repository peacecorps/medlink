class SMS < ActiveRecord::Base
  MAX_LENGTH = 160

  self.table_name = "messages"

  enum direction: [ :incoming, :outgoing ]

  belongs_to :user
  belongs_to :phone
  belongs_to :twilio_account
  has_one :request, foreign_key: :message_id

  validates_presence_of :phone, :twilio_account, :number, :direction

  include Concerns::Immutable
  immutable :user_id, :twilio_account_id, :number, :direction, :text

  def duplicates within: nil
    scope = SMS.incoming.where(text: text, number: number).where.not(id: id)
    within ? scope.where("created_at >= ?", within.ago) : scope
  end

  def last_duplicate within: nil
    duplicates(within: within).newest
  end
end
