class UserForm < Reform::Form
  property :first_name
  property :last_name
  property :role
  property :location
  property :time_zone

  validates :first_name, :last_name, :role, :location, presence: true
  validate :check_phone_numbers

  collection :phones do
    property :number
    validate :has_country_code

    def has_country_code
      unless number.start_with? '+'
        errors.add :number, "should include a country code (e.g. +1 for the US)"
      end
    end
  end

  def model_name
    ::ActiveModel::Name.new User
  end

  def initialize user, editor:
    Pundit.authorize editor, user, :update?
    super user
  end

  def validate params
    self.phone_numbers = params[:phone_numbers]
    super params
  end

  def flash
    if changed?
      { notice: I18n.t!("flash.user.changes", changes: change_summary) }
    else
      { alert: I18n.t!("flash.user.no_changes") }
    end
  end

  def phone_numbers
    phones.map(&:number).compact.join ", "
  end

  def phone_numbers= numbers
    self.phones = numbers.split(/[,\n]/).map { |n| Phone.new number: n.strip }
  end

  def pcv_id
    model.pcv_id
  end

  def save
    super
    # FIXME: I _really_ don't like that this can pass validations and then fail to save
    #   Need to find a better way to represent this
    model.save!
  end

  private

  def check_phone_numbers
    phone_errors = phones.map { |p| p.errors[:number] }.flatten.uniq
    errors[:phone_numbers] = phone_errors if phone_errors.any?
  end

  def changed_fields
    changed.select { |k,v| v }.keys - %w( country_id )
  end

  def change_summary
    changed_fields.map { |k| "#{k}=[#{new_value_for k}]" }.join "; "
  end

  def new_value_for key
    key == "phones" ? phone_numbers : send(key)
  end
end
