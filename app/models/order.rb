class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :supply

  has_one :response

  validates_presence_of :user,   message: "unrecognized"
  validates_presence_of :supply, message: "is missing"

  validates_presence_of :location, message: "is missing"

  scope :responded,   -> { includes(:response).references(:response
    ).where("responses.id IS NOT NULL").order("responses.id DESC") }
  scope :unresponded, -> { includes(:response).references(:response
    ).where("responses.id IS NULL")     }

  scope :past_due, -> { unresponded.where(["orders.created_at < ?",
    3.business_days.ago]) }
  scope :pending,  -> { unresponded.where(["orders.created_at >= ?",
    3.business_days.ago]) }

  def response_time
    #FIXME: Absolute delta response time or remove weekends
    response && ((response.created_at - created_at) / (60 * 60 * 24)).round(1)
  end

  def how_past_due
    # How many days over 3 are we past due?
    if response
      past_due = (
        (3.business_days.after(created_at) -
          response.created_at) / (60 * 60 * 24)
      ).round(1)
      if (past_due < 3)
        0
      else
        (past_due - 3).round(1)
      end
    end
  end

  def country_id
    # FIXME: make this an actual column
    user.country_id
  end

  def responded?
    response.present?
  end

  def responded_at
    response && response.created_at
  end

  def fulfilled?
    fulfilled_at.present?
  end

  validates_uniqueness_of :supply_id, scope: :user_id,
    conditions: -> { unresponded }

  def self.human_attribute_name(attr, options={})
    {
      user:   "PCV ID",
      supply: "Supply"
    }[attr] || super
  end

  def self.create_from_text data
    user   = User.lookup   data[:pcvid]
    supply = Supply.lookup data[:shortcode]

    create!({
      user_id:   user.try(:id),
      phone:     data[:phone],
      email:     user.try(:email),
      supply_id: supply.try(:id),
      location:  data[:loc] || user.try(:location)
    })
  end

  def confirmation_message
    if self.valid?
      I18n.t "order.confirmation"
    else
      errors.full_messages.join ","
    end
  end
end
