class Admin::UsersController < AdminController
  before_action :set_user, except: [:new, :create, :uploadCSV]
  around_filter :catch_no_record

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
      # Tag P7 below
      redirect_to new_admin_user_path,
        notice: 'Success! You have added a new user to PC Medlink'
      # FIXME: email password to the user
    else
      render :new
    end
  end

  def edit
  end

  def update
    # TODO: Clean this up: The edge case here is countries: db ids are
    #    ints, not the strings that we get as params, and we want to
    #    display country=name instead of country_id=id
    field_chgs = []
    user_params.each do |key,nval|
      oval = @user[key]
      if oval != nval && !nval.empty?
        if key == "country_id"
          next if oval.to_s == nval.to_s
          nval = Country.find(nval).name if key == "country_id"
          field_chgs << ["country", nval]
        else
          field_chgs << [key, nval]
        end
      end
    end

    if @user.update_attributes user_params
      _flash = if field_chgs.any?
        # P8
        change_desc = field_chgs.map { |k,v| "#{k}=[#{v}]" }.join "; "
        { success: "Success! You have made the following changes to this user account: #{change_desc}" }
      else
        { notice: "No changes made" }
      end
      redirect_to new_admin_user_path, _flash
    else
      render :edit
    end
  end

  def uploadCSV
    upload = User::Upload.new params[:csv], overwrite: params[:overwrite] == '1'
    upload.run!

    if upload.errors.present?
      send_data upload.errors, type: 'text/csv', filename: 'invalid_users.csv'
      flash[:error] = "CSV has invalid entries!"
    else
      flash[:success] =  "Successully uploaded users information!"
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
    params.require(:user).permit [:first_name, :last_name, :location,
      :country_id, :phone, :email, :pcv_id, :role, :pcmo_id, :remember_me, :time_zone]
  end

  def users_by_country
    User.includes(:country).to_a.group_by(&:country).map do |c,us|
      [c, us.map { |u| [u, u.id] }]
    end
  end

  def catch_no_record
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to new_admin_user_path,
      :flash => { :error => "Please select a volunteer to edit." }
  end
end

