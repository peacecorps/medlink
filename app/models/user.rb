class User < ActiveRecord::Base
  devise :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope { where(active: true) }

  enum role: [ :pcv, :pcmo, :admin ]
  def self.role_names
    { "PCV" => "pcv", "PCMO" => "pcmo", "Admin" => "admin" }
  end
  def role= r
    r = r.downcase if r.respond_to?(:downcase)
    super r
  end
  scope :non_admins, -> { where.not(role: User.roles[:admin]) }

  belongs_to :country

  paginates_per 10

  has_many :requests
  has_many :orders
  has_many :responses
  has_many :receipt_reminders

  has_many :phones, dependent: :destroy
  has_many :messages, class_name: "SMS"

  has_many :submitted_requests, foreign_key: "entered_by", class_name: "Request"
  has_many :roster_uploads, foreign_key: "uploader_id"

  validates_presence_of :country, :location, :first_name, :last_name, :role
  validates :pcv_id, presence: true, uniqueness: true, if: :pcv?
  validates :time_zone, inclusion: { in: Country.time_zones.map(&:name) }

  scope :past_due, -> { where ["waiting_since  < ?", DueDate.cutoff] }
  scope :pending,  -> { where ["waiting_since >= ?", DueDate.cutoff] }

  before_validation on: :create do |u|
    u.time_zone  = u.country.time_zone unless u.time_zone.present?
    u.password ||= SecureRandom.hex(64)
  end

  def primary_phone
    @_primary_phone ||= phones.first
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def textable?
    primary_phone.present?
  end

  def send_text message
    return unless primary_phone
    UserTexter.new(phone: primary_phone, twilio_account: country.twilio_account).send message
  end

  def available_supplies
    country.available_supplies
  end

  def sms_contact_number
    n = country.twilio_account.number.to_s
    "#{n[0..-11]} (#{n[-10..-8]}) #{n[-7..-5]}-#{n[-4..-1]}"
  end

  def inactivate!
    update! active: false
  end

  def personal_requests
    Request.where user_id: id, entered_by: id
  end

  def ensure_secret_key!
    update! secret_key: ApiAuth.generate_secret_key unless secret_key.present?
  end
end
