class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :pcv, :pcmo, :admin ]
  def self.role_names
    { "PCV" => "pcv", "PCMO" => "pcmo", "Admin" => "admin" }
  end
  def role= r
    r = r.downcase if r.respond_to?(:downcase)
    super r
  end

  belongs_to :country

  %i( requests orders responses ).each do |name|
    has_many name, dependent: :destroy
  end

  paginates_per 10

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  validates_presence_of :country, :location, :first_name, :last_name, :role
  validates_presence_of :pcv_id, if: :pcv?
  validates :pcv_id, uniqueness: true, if: :pcv?
  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map(&:name) }

  def self.due_cutoff
    now    = Time.now
    oldest = now.at_beginning_of_month
    now.day < 3 ? oldest - 1.month : oldest
  end

  scope :past_due, -> { where ["waiting_since  < ?", due_cutoff] }
  scope :pending,  -> { where ["waiting_since >= ?", due_cutoff] }

  def self.find_by_pcv_id str
    where(['lower(pcv_id) = ?', str.downcase]).first!
  end

  def self.find_by_phone_number number
    Phone.lookup(number).user
  end

  def update_waiting!
    update_attributes(
      waiting_since:     orders.without_responses.minimum(:created_at),
      last_requested_at: orders.maximum(:created_at)
    )
  end

  def primary_phone
    @_primary_phone ||= phones.first
  end

  def accessible model
    if admin?
      model.all
    elsif pcmo?
      model.where(country_id: country_id)
    else
      model.where(user_id: id)
    end
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def mark_updated_orders
    orders.without_responses.
      group_by(&:supply_id).
      select { |_,dups| dups.count > 1 }.
    each do |_,os|
      os.sort_by(&:created_at).slice(0..-2).each { |o| o.touch :duplicated_at }
    end
  end

  def textable?
    primary_phone.present?
  end

  def send_text message
    twilio = country.twilio_account
    to     = primary_phone.try :number
    return unless to
    twilio.send_text to, message
  rescue => e
    unless e.to_s =~ /is not a mobile number/
      Rails.logger.error "Error while texting #{email} - #{e}"
      raise
    end
  end

  def available_supplies
    country.supplies
  end

  def sms_contact_number
    n = country.twilio_account.number.to_s
    "#{n[0..-11]} (#{n[-10..-8]}) #{n[-7..-5]}-#{n[-4..-1]}"
  end

  def welcome_video
    if self.pcv?
      "yTNr0Nh7WYU"
    else
      "KkXb_5kkfwk"
    end
  end

  def record_welcome!
    self.update!(welcome_video_shown_at: Time.now)
  end

  def welcome_video_seen?
    !self.welcome_video_shown_at.nil?
  end
end
