class Api::V1::UsersController < Api::V1::BaseController
  def index
    authorize :roster, :show?

    rows = Roster.for_user(current_user).rows.includes(:phones, :country)
    if params[:country_id]
      rows = rows.where(country_id: params[:country_id])
    end

    @users = RosterUserPresenter.decorate_collection rows
  end

  def update
    user = UserForm.new User.find(params[:id]), submitter: current_user
    if save_form user, params[:user]
      render json: { status: "ok" }
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end
end
