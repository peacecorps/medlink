class Api::V1::UsersController < Api::V1::BaseController
  def index
    authorize :roster, :show?
    @users = RosterUserPresenter.decorate_collection \
      Roster.for_user(current_user).rows.includes :phones
  end
end
