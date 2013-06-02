class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :country_id

  belongs_to :country
  has_many :orders
  validates_presence_of :country

  def accessible_orders
    is_admin? ? Order.where(users: {country_id: country_id}) : orders
  end
  def is_admin?
    role == 'admin'
  end

  def self.lookup str
    where(['lower(pcv_id) = ?', str.downcase]).first
  end
end
