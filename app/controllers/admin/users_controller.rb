class Admin::UsersController < AdminController
  before_action :set_user, except: [:new, :create]
  around_filter :catch_no_record

  def new
    @users = User.all.group_by &:country
    @user  = User.new
  end

  def create
    if u = params[:edit_user]
      # FIXME: This is a terrible hack to accomodate the edit user
      #    selection being on the new user (/admin home) page, and
      #    should be removed once we have a javascripty user
      #    selection mechanism
      id = u =~ /\((.*)\)/ && $1
      user = User.where(pcv_id: id).first!
      redirect_to edit_admin_user_path(user) and return
    end

    password = 'password' # Devise.friendly_token.first 8

    @users = User.all.group_by &:country
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
    # TODO: clean this up
    # The edge case here is countries: db ids are ints, not the strings
    # that we get as params, and we want to display country=name instead
    # of country_id=id
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
    change_desc = field_chgs.map { |k,v| "#{k}=[#{v}]" }.join "; "

    if @user.update_attributes user_params
      redirect_to new_admin_user_path,
        notice: 'Success! You have made the following changes ' +
          "to this user account: #{change_desc}"
    else
      render :edit
    end
  end

  private # ----------

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit [:first_name, :last_name, :location,
      :country_id, :phone, :email, :pcv_id, :role, :pcmo_id, :remember_me]
  end

  def catch_no_record
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to new_admin_user_path,
      :flash => { :error => "Please select a volunteer to edit." }
  end
end

