class Api::V1::UsersController < Api::V1::BaseController
  def index
    authorize :roster, :show?

    @users = Roster.for_user(current_user).rows.includes(:phones)
    if params[:country_id]
      @users = @users.where(country_id: params[:country_id])
    end
  end

  def update
    user = UserForm.new User.find(params[:id]), submitter: current_user

    user.phone_numbers = params[:user][:phones].join(", ") if params[:user][:phones]

    if save_form user, params[:user]
      render json: { status: "ok" }
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end
end
