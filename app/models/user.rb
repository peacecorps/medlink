class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :country_id, :first_name, :last_name, :pcv_id, :city, :role, :phone

  belongs_to :country
  has_many :orders
  validates_presence_of :city, :country, :first_name, :last_name, :pcv_id
  validates :pcv_id, uniqueness: true

  def as_json(args)
    super(args.merge(include: [:country]))
  end

  def is_admin?
    role == 'admin'
  end
  
  def accessible_orders
    is_admin? ? Order.where(users: {country_id: country_id}) : orders
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
end
