class Order < ActiveRecord::Base
  attr_accessible :confirmed, :email, :extra, :fulfilled, :pc_hub_id, 
    :phone, :user_id, :requests_attributes, :instructions

  belongs_to :user
  has_many :requests

  validates_presence_of :user,   message: "unrecognized"
  accepts_nested_attributes_for :requests

  # UI wants users included with all output
  def as_json(args)
    super(args.merge(include: [{:user => {:include => :country}}, :requests]))
  end
  default_scope eager_load(:user, :requests)

  scope :unfulfilled, where(fulfilled: false)

  def self.human_attribute_name(attr, options={})
    { 
      user:   "PCV ID"
    }[attr] || super
  end

  def self.create_from_text data
    user   = User.where(pcv_id: data[:pcvid]).first || raise("Unrecognized PCVID")
    supply = Supply.where(shortcode: data[:shortcode]).first || raise("Unrecognized shortcode")

    create!({
      user_id:   user.try(:id),
      phone:     data[:phone],
      email:     user.try(:email),
      requests_attributes: [{
        supply_id: supply.try(:id),
        dose:      "#{data[:dosage_value]}#{data[:dosage_units]}",
        quantity:  data[:qty]
      }]
    })
  end

  def confirmation_message
    if self.valid?
      "Your request has been processed and action will be taken within 24 hours."
    else
      errors.full_messages.join ","
    end
  end

  def confirm!
    update_attribute :confirmed, true
  end

  def fulfill! instructions
    update_attributes({
      fulfilled:    true,
      instructions: instructions
    })
  end

  def dup_hash
    {
      user:     user.id,
      requests: requests.map { |r| [r.supply_id, r.dose, r.quantity] }.sort_by(&:first)
    }
  end

  def self.create! attrs={}
    # Prevent creating an order with identical user and requests
    if user = User.find(attrs[:user_id])
      dh   = new(attrs).dup_hash
      dups = user.orders.unfulfilled.select { |o| o.dup_hash == dh }
      raise "Cannot create duplicate order" unless dups.empty?
    end

    super
  end
end
