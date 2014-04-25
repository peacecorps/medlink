class Admin::UsersController < AdminController
  def set_active_country
    country = Country.find params.require(:country)[:country_id]
    session[:active_country_id] = country.id
    redirect_to :back, notice: I18n.t!("flash.country_selected", country: country.name)
  end

  def new
    @users = users_by_country
    @user  = User.new
  end

  def create
    # This is a kludge to accomodate the edit user
    #   selection being on the new user (/admin home) page
    if id = params[:edit_user]
      user = User.find id
      redirect_to edit_admin_user_path(user) and return
    end

    @users = users_by_country
    @user = User.new user_params.merge(password: SecureRandom.hex)

    if @user.save
      redirect_to new_admin_user_path,
        notice: I18n.t!("flash.user_added")
    else
      render :new
    end
  end

  def edit
    @user  = User.find params[:id]
    @users = users_by_country
  end

  def update
    @user  = User.find params[:id]
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
      @users = users_by_country
      render :edit
    end
  end

  def upload_csv
    upload = run_upload!
    if upload.errors.present?
      send_data upload.errors, type: 'text/csv', filename: 'invalid_users.csv'
    else
      flash[:success] = I18n.t! "flash.valid_csv", users: upload.added.count
      redirect_to new_admin_user_path
    end

  rescue => e
    redirect_to new_admin_user_path, flash: { error: e.message }
  end

  private # ----------

  def user_params
    params.require(:user).permit(:first_name, :last_name, :location,
      :country_id, :email, :pcv_id, :role, :pcmo_id, :remember_me, :time_zone,
      phones_attributes: [:id, :number, :_destroy])
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
