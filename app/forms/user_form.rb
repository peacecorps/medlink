class UserForm < Reform::Form
  property :first_name
  property :last_name
  property :location
  property :country_id
  property :email
  property :pcv_id
  property :role
  property :time_zone
  validate :email, :first_name, :last_name, :pcv_id, :role, :location, :time_zone

  collection :phones do
    property :number
    validate :number
  end

  def initialize *args
    super
    @old_attrs = model.attributes
  end


  def flash
    if diff.changed?
      { success: I18n.t!("flash.user.changes", changes: diff.summary) }
    else
      { notice: I18n.t!("flash.user.no_changes") }
    end
  end

  private

  def diff
    User::Change.new @old_attrs, model
  end

end
