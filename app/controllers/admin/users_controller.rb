class Admin::UsersController < AdminController
  # This n+1 comes from each welcome email fetching country supplies, which we don't
  #   care about since those are handled out-of-band in production
  around_action :skip_bullet, only: [:create] if Rails.env.test?

  def set_country
    current_user.update country: Country.find(params[:country][:id])
    redirect_to (params[:next] || :back)
  end

  def new
    @user = UserForm.new User.new
    authorize @user

    @upload = User::Upload.new(country: current_user.country)
  end

  def create
    @user = UserForm.new User.new

    if validate @user, params[:user]
      redirect_to new_admin_user_path, notice: I18n.t!("flash.user.added")
    else
      @upload = User::Upload.new(country: current_user.country)
      render :new
    end
  end

  def select
    redirect_to edit_admin_user_path(params[:edit][:user_id])
  end

  def edit
    @user = UserForm.new User.find params[:id]
  end

  def update
    @user = UserForm.new User.find params[:id]

    if validate @user, params[:user]
      @user.save
      redirect_to new_admin_user_path, @user.flash
    else
      render :edit
    end
  end

  def inactivate
    user = User.find params[:id]
    authorize user
    user.inactivate!
    redirect_to :back, notice: I18n.t!("flash.user.inactive_user", user: user.name)
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
end
