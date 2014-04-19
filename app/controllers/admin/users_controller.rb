class Admin::UsersController < AdminController
  before_action :set_user, except: [:new, :create, :upload_csv]

  def new
    @users = users_by_country
    @user  = User.new
  end

  def create
    # FIXME: This is a hack to accomodate the edit user
    #    selection being on the new user (/admin home) page
    if id = params[:edit_user]
      user = User.find id
      redirect_to edit_admin_user_path(user) and return
    end

    password = 'password' # Devise.friendly_token.first 8

    @users = users_by_country
    @user = User.new user_params.merge(password: password)

    if @user.save
      redirect_to new_admin_user_path,
        notice: I18n.t!("flash.user_added")
      # FIXME: email password to the user
    else
      render :new
    end
  end

  def edit
    @users = users_by_country
  end

  def update
    _attrs = @user.attributes
    if @user.update_attributes user_params
      diff = User::Change.new _attrs, @user
      _flash = if diff.changed?
        { success: I18n.t!("flash.changes", changes: diff.summary) }
      else
        { notice: I18n.t!("flash.no_changes") }
      end
      redirect_to new_admin_user_path, flash: _flash
    else
      render :edit
    end
  end

  def upload_csv
    upload = run_upload!
    if upload.errors.present?
      # TODO: notify of errors somehow (we can't flash, since we're not rendering a page)
      send_data upload.errors, type: 'text/csv', filename: 'invalid_users.csv'
    else
      flash[:success] = I18n.t! "flash.valid_csv", users: upload.added.count
      redirect_to new_admin_user_path
    end

  rescue => e
    redirect_to new_admin_user_path, flash: { error: e.message }
  end

  private # ----------

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :location,
      :country_id, :email, :pcv_id, :role, :pcmo_id, :remember_me, :time_zone,
      phone_numbers_attributes: [:id, :display, :_destroy])
  end

  def users_by_country
    User.includes(:country).to_a.group_by(&:country).map do |c,us|
      [c.name, us.map { |u| [u.name, u.id] }]
    end
  end

  def run_upload!
    country = Country.find params[:country_id]
    upload  = User::Upload.new country, params[:csv], overwrite: params[:overwrite].present?
    upload.tap &:run!
  end
end
