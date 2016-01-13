# TODO
# * Refactor, place, and clean
# * Allow admins some way to opt-out of cross country searching
# * Animate search icon while searching
# * Only allow one running search at a time
ApiUserPresenter = Class.new Draper::Decorator do
  decorates User
  delegate :id, :email, :first_name, :last_name, :location, :active?

  def role
    case model.role.to_s
    when "pcv"
      "PCV #{model.pcv_id}"
    when "pcmo"
      "PCMO"
    when "admin"
      "Admin"
    end
  end

  def phones
    model.phones.map &:number
  end
end

class Pager
  include Enumerable

  def initialize scope:, presenter: nil
    @scope, @presenter = scope, presenter
  end

  def render params, &block
    sort   =  params[  :sort].presence || :id
    dir    =  params[   :dir].presence || :asc
    filter =  params[:filter].presence
    page   = (params[  :page].presence || 1).to_i
    per    = 25

    @scope.
      order(build_sort(sort, dir)). # TODO: whitelist `sort`
      find_each(batch_size: per * 5).
      lazy.
      map    { |r| yield presented r }.
      select { |h| matches filter, h }.
      drop( per * (page - 1) ).
      first( per )
  end

  private

  def build_sort col, dir
    col = @scope.column_names.include?(col.to_s) ? col : "id"
    dir = %w(asc desc).include?(dir.to_s) ? dir : "asc"
    { col => dir }
  end

  def presented record
    @presenter ? @presenter.new(record) : record
  end

  def matches string, hash
    return true unless string
    tokens = string.downcase.split /\s+/
    values = hash.values.map { |v| v.to_s.downcase }

    tokens.all? { |t| values.any? { |v| v.include? t } }
  end
end


class Api::V1::UsersController < Api::V1::BaseController
  def index
    authorize :roster, :show?
    @users = RosterUserPresenter.decorate_collection \
      Roster.for_user(current_user).rows.includes(:phones)

    # FIXME ^ clean this up, paginate, whitelist sort column, &c
    @users = Roster.for_user(current_user).rows.includes(:phones)
    if params[:sort].present?
      dir = params[:dir]
      dir = "asc" unless dir.present?
      @users = @users.order(params[:sort] => dir)
    end
    @users = @users.first 10

    pager  = Pager.new \
      scope:     Roster.for_user(current_user).rows.includes(:phones),
      presenter: ApiUserPresenter

    render json: {
      users: pager.render(params) do |u|
        {
          id:         u.id,
          email:      u.email,
          first_name: u.first_name,
          last_name:  u.last_name,
          role:       u.role,
          phones:     u.phones,
          active:     u.active?
        }
      end
    }
  end
end
