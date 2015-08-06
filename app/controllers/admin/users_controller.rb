class Admin::UsersController < AdminController
  # This n+1 comes from each welcome email fetching country supplies, which we don't
  #   care about since those are handled out-of-band in production
  around_action :skip_bullet, only: [:create] if Rails.env.test?

  def set_country
    id = params[:country][:country_id]
    redirect_to :back and return unless id.present?
    authorize current_user, :update?
    current_user.update country: Country.find(id)
    redirect_to :back, notice: I18n.t!("flash.country_selected", country: current_user.country.name)
  end

  def new
    @user = User.new
    authorize @user

    @upload = User::Upload.new(country: current_user.country)
  end

  def create
    @user = User.new user_params.merge(password: SecureRandom.hex)
    authorize @user

    if @user.save
      redirect_to new_admin_user_path, notice: I18n.t!("flash.user.added")
    else
      @upload = User::Upload.new(country: current_user.country)
      render :new
    end
  end

  def edit
    if params[:edit]
      redirect_to edit_admin_user_path(params[:edit][:user_id]) and return
    end
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    authorize @user
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
    @upload = User::Upload.new(
      country:   Country.find(params[:country_id]),
      overwrite: params[:overwrite].present?
    )

    authorize @upload, :run?
    @upload.run! params[:csv]

    if @upload.successful?
      flash[:success] = I18n.t! "flash.csv.valid", users: @upload.rows.count
      redirect_to new_admin_user_path
    end
  end

  private # ----------

  def user_params
    p = params.require(:user).permit(:first_name, :last_name, :location,
      :country_id, :email, :pcv_id, :role, :time_zone,
      phones_attributes: [:id, :number, :_destroy])
    p[:phones_attributes].reject! { |_,ps| ps[:number].empty? }
    p
  end
end
