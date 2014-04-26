class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  enum role: [ :pcv, :pcmo, :admin ]
  def self.role_names
    { "PCV" => "pcv", "PCMO" => "pcmo", "Admin" => "admin" }
  end

  belongs_to :country

  %i( requests orders responses ).each do |name|
    has_many name, dependent: :destroy
  end

  has_many :phones, dependent: :destroy
  accepts_nested_attributes_for :phones, allow_destroy: true

  validates_presence_of :country, :location, :first_name, :last_name, :role
  validates_presence_of :pcv_id, :if => :pcv?
  validates :pcv_id, uniqueness: true, :if => :pcv?
  validates :time_zone, inclusion: {in: ActiveSupport::TimeZone.all.map(&:name) }

  def self.find_by_pcv_id str
    where(['lower(pcv_id) = ?', str.downcase]).first!
  end

  def self.find_by_phone_number number
    Phone.lookup(number).user
  end

  def primary_phone
    @_primary_phone ||= phones.first
  end

  def self.pcmos_by_country
    pcmo.includes(:country).group_by &:country
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

  # We want to send mail in the background by default, but still need
  #   access to the underlying method to send things from the background
  def send_reset_password_instructions now=false
    return super() if now
    MailerJob.enqueue :forgotten_password, id
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
end
