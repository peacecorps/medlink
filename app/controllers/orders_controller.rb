class OrdersController < ApplicationController
  def index
    @timeline = Timeline.new current_user
    authorize @timeline, :show?
    render "timelines/show"
  end

  def manage
    authorize :user, :respond?
    users = current_user.country.users
    @past_due = sort_table users.past_due.includes(orders: :supply), prefix: "past_due", default: { waiting_since: :asc }
    @pending  = sort_table users.pending.includes(orders: :supply),  prefix: "pending",  default: { waiting_since: :asc }
  end
end
