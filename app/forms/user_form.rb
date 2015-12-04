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
  validate :admins_cant_demote_themselves
  validate :check_phone_form

  def model_name
    ::ActiveModel::Name.new User
  end

  def initialize *args
    super
    @phone_form = PhoneSyncForm.new model
    Pundit.authorize submitter, model, :update?
  end

  def flash
    if change_summary.present?
      { notice: I18n.t!("flash.user.changes", changes: change_summary) }
    else
      { alert: I18n.t!("flash.user.no_changes") }
    end
  end

  def phone_numbers
    @phone_form.to_s
  end
  def phone_numbers= numbers
    @phone_form.validate numbers: numbers
  end

  def save
    super
    @phone_form.save
  end

  private

  def check_phone_form
    @phone_form.errors[:numbers].each do |e|
      errors.add :phone_numbers, e
    end
  end

  def admins_cant_demote_themselves
    if submitter == model && submitter.admin? && role != :admin
      errors.add :role, "can't demote yourself"
    end
  end

  def changed_fields
    base = changed.select { |_,v| v }.keys
    @phone_form.changed? ? base + %w( phone_numbers ) : base
  end

  def change_summary
    changed_fields.map { |k| summarize k }.join "; "
  end

  def country_name
    Country.find(country_id).name
  end

  def summarize key
    if key == "country_id"
      "country=#{country_name}"
    else
      "#{key}=#{send key}"
    end
  end
end
