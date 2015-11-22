class UserForm < Reform::Form
  property :first_name
  property :last_name
  property :location
  property :country_id
  property :email
  property :pcv_id
  property :role
  property :time_zone

  collection :phones

  #def initialize user, params:
  #  @user   = user
  #  @params = params
  #end

  ##_attrs = @user.attributes
  ##if @user.update_attributes user_params
  ##  diff = User::Change.new _attrs, @user
  #def save
  #  raise
  #end

  #def flash
  #  if diff.changed?
  #    { success: I18n.t!("flash.user.changes", changes: diff.summary) }
  #  else
  #    { notice: I18n.t!("flash.user.no_changes") }
  #  end
  #end

  #private

  #def safe_params
  #  params.require(:user).permit(:first_name, :last_name, :location,
  #    :country_id, :email, :pcv_id, :role, :time_zone, :phones)
  #end
end
