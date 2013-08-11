class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :country
  has_many :orders
  validates_presence_of :country, :location, :phone, :first_name, :last_name, :pcv_id
  validates :pcv_id, uniqueness: true

  Roles = {
    pcv:   'PCV',
    pcmo:  'PCMO',
    admin: 'Admin'
  }

  Roles.each do |type, _|
    define_method :"#{type}?" do
      role.to_sym == type
    end

    scope type.to_s.pluralize, -> { where(role: type) }
  end

  def self.pcmos_by_country
    pcmos.includes(:country).group_by &:country
  end

  # FIXME: denormalize on country
  def accessible_orders
    admin? ? Order.includes(:user).where(
      users: {country_id: country_id}) : orders
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
    "#{name} (#{pcv_id})"
  end
end
