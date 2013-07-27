class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :country
  has_many :orders
  validates_presence_of :city, :country, :first_name, :last_name, :pcv_id
  validates :pcv_id, uniqueness: true

  def admin?
    role == 'admin'
  end

  # FIXME: denormalize on country
  def accessible_orders
    admin? ? Order.includes(:user).where(
      users: {country_id: country_id}) : orders
  end

  def self.lookup str
    where(['lower(pcv_id) = ?', str.downcase]).first
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
end
