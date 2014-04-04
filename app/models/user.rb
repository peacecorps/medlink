class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :pcv, :pcmo, :admin ]

  belongs_to :country
  has_many :orders, dependent: :destroy

  has_many :phone_numbers, dependent: :destroy
  accepts_nested_attributes_for :phone_numbers, allow_destroy: true

  validates_presence_of :country, :location, :first_name, :last_name, :role
  validates_presence_of :pcv_id, :if => :pcv?
  validates :pcv_id, uniqueness: true, :if => :pcv?
  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map {|t| t.name}}

  def self.find_by_phone_number number
    PhoneNumber.lookup(number).user
  end

  def primary_phone
    @_primary_phone ||= phone_numbers.first
  end

  def self.pcmos_by_country
    pcmo.includes(:country).group_by &:country
  end

  def pcvs
    if admin?
      # FIXME: this clearly includes non-pcv users
      # Should the implementation or name change?
      User.all
    elsif pcmo?
      pcvs_shared = country.users.pcv
      # TODO: resolve this name similarly
      pcvs_shared << self
    else
      raise "No PCVs for #{role}"
    end
  end

  # FIXME: denormalize on country
  def accessible_orders
    if admin?
      Order.all
    elsif pcmo?
      Order.includes(:user).where users: {country_id: country_id}
    else
      orders
    end
  end

  def self.lookup str
    where(['lower(pcv_id) = ?', str.downcase]).first ||
    raise("Unrecognized PCVID")
  end

  def send_reset_password_instructions opts={}
    if opts[:async] == false
      super()
    else
      MailerJob.enqueue :forgotten_password, id
    end
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    if pcv_id
      "#{name} (#{pcv_id})"
    else
      "#{name} (#{role})"
    end
  end

end
