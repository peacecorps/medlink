class UserForm < Reform::Form
  property :submitter, virtual: true
  property :phone_numbers, virtual: true
  property :first_name
  property :last_name
  property :role
  property :location
  property :time_zone
  property :country_id
  property :pcv_id

  validates :first_name, :last_name, :role, :location, :country_id, :pcv_id, presence: true
  validate :check_phone_numbers
  validate :admins_cant_demote_themselves

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

  def initialize *args
    super
    Pundit.authorize submitter, model, :update?
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

  private

  def check_phone_numbers
    phone_errors = phones.map { |p| p.errors[:number] }.flatten.uniq
    errors.add :phone_numbers, phone_errors.first if phone_errors.any?
  end

  def admins_cant_demote_themselves
    if submitter == model && submitter.admin? && role != :admin
      errors.add :role, "can't demote yourself"
    end
  end

  def changed_fields
    changed.select { |k,v| v }.keys - %w( country_id )
  end

  def change_summary
    changed_fields.map { |k| "#{k}=#{new_value_for k}" }.join "; "
  end

  def new_value_for key
    key == "phones" ? phone_numbers : send(key)
  end
end
