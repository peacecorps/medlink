class Admin::UsersController < AdminController
  before_action :set_user, except: [:new, :create]

  def new
    if u = params[:edit_user]
      # FIXME: This is a terrible hack to accomodate the edit user
      #    selection being on the new user (/admin home) page, and
      #    should be removed once we have a javascripty user
      #selection mechanism
      id = u =~ /\((.*)\)/ && $1
      user = User.where(pcv_id: id).first!
      redirect_to edit_admin_user_path(user)
    end

    @users = User.all.group_by &:country
    @user  = User.new
  end

  def create
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
# FIXME: Changed <list of field changes> to actual values.
    if @user.update_attributes user_params
      redirect_to new_admin_user_path,
        notice: 'Success! You have made the following changes " +
          "to this user account: <list of field changes>'
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
end

