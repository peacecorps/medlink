class Admin::UsersController < AdminController
  def set_active_country
    id = params[:country][:country_id]
    redirect_to :back and return unless id.present?
    country = Country.find id
    session[:active_country_id] = country.id
    redirect_to :back, notice: I18n.t!("flash.country_selected", country: country.name)
  end

  def new
    @user = User.new
  end

  def create
    # This is a kludge to accomodate the edit user
    #   selection being on the new user (/admin home) page
    if id = params[:edit_user]
      if id.present?
        user = User.find id
        redirect_to edit_admin_user_path(user) and return
      else
        redirect_to new_admin_user_path, notice: I18n.t!("flash.user.none_selected") and return
      end
    end

    @user = User.new user_params.merge(password: SecureRandom.hex)

    if @user.save
      MailerJob.perform_later "welcome", @user.id
      redirect_to new_admin_user_path,
        notice: I18n.t!("flash.user.added")
    else
      render :new
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user  = User.find params[:id]
    _attrs = @user.attributes
    if @user.update_attributes user_params
      diff = User::Change.new _attrs, @user
      _flash = if diff.changed?
        { success: I18n.t!("flash.user.changes", changes: diff.summary) }
      else
        { notice: I18n.t!("flash.user.no_changes") }
      end
      redirect_to new_admin_user_path, flash: _flash
    else
      render :edit
    end
  end

  def upload_csv
    @upload = run_upload!
    if @upload.errors.any?
      @user = User.new
      render :new
    else
      @upload.added.each { |u| MailerJob.perform_later "welcome", u.id }
      flash[:success] = I18n.t! "flash.csv.valid", users: @upload.added.count
      redirect_to new_admin_user_path
    end
  end

  def editable_users
    User.where(country: active_country_id).map { |u| [u.name, u.id] }
  end
  helper_method :editable_users

  private # ----------

  def user_params
    p = params.require(:user).permit(:first_name, :last_name, :location,
      :country_id, :email, :pcv_id, :role, :time_zone,
      phones_attributes: [:id, :number, :_destroy])
    p[:phones_attributes].reject! { |_,ps| ps[:number].empty? }
    p
  end

  def run_upload!
    upload = User::Upload.new params[:country_id], params[:csv], overwrite: params[:overwrite].present?
    upload.tap &:run!
  end

end
