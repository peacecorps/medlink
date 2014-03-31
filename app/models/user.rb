class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :country
  has_many :orders, dependent: :destroy

  Roles = {
    pcv:   'Peace Corps Volunteer',
    pcmo:  'Peace Corps Medical Officer',
    admin: 'Admin'
  }

  validates_presence_of :country, :location, :phone, :first_name,
    :last_name, :role
  validates_presence_of :pcv_id, :if => :pcv?
  validates :role, inclusion: {in: Roles.keys.map(&:to_s)}
  validates :pcv_id, uniqueness: true, :if => :pcv?
  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map {|t| t.name}}

  Roles.each do |type, _|
    # define pcv?, pcmo?, admin? methods
    define_method :"#{type}?" do
      role.to_sym == type
    end

    # define pcvs, pcmos, admins scopes
    scope type.to_s.pluralize, -> { where(role: type) }
  end

  def self.pcmos_by_country
    pcmos.includes(:country).group_by &:country
  end

  def pcvs
    case role.to_sym
    when :admin
      # FIXME: this clearly includes non-pcv users
      # Should the implementation or name change?
      User.all
    when :pcmo
      pcvs_shared = country.users.pcvs
      # TODO: resolve this name similarly
      pcvs_shared << self
    else
      raise "No PCVs for #{role}"
    end
  end

  # FIXME: denormalize on country
  def accessible_orders
    case role.to_sym
    when :admin
      Order.all
    when :pcmo
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

