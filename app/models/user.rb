class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :country_id, :first_name, :last_name, :pcv_id, :city, :role

  belongs_to :country
  has_many :orders
  validates_presence_of :city, :country, :first_name, :last_name, :pcv_id

  def accessible_orders
    is_admin? ? Order.where(users: {country_id: country_id}, fulfilled: false) : orders
  end
  def is_admin?
    role == 'admin'
  end

  def self.lookup str
    where(['lower(pcv_id) = ?', str.downcase]).first
  end
end
