class OrdersController < ApplicationController
  def manage
    authorize :user, :respond?
    users = current_user.country.users
    @past_due = sort_table :past_due do |t|
      t.scope   = users.past_due.includes orders: :supply
      t.default = { waiting_since: :asc }
    end
    @pending = sort_table :pending do |t|
      t.scope   = users.pending.includes orders: :supply
      t.default = { waiting_since: :asc }
    end
  end
end
