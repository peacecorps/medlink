class OrdersController < ApplicationController
  def index
    @orders = current_user.orders.
      includes(:supply, :response).
      page(params[:page])
  end

  def manage
    authorize! :respond, User
    @past_due  = accessible_orders.past_due.page params[:past_due_page]
    @pending   = accessible_orders.pending.page params[:pending_page]
    @responses = accessible_responses.page params[:response_page]
  end

  def active_country?
    !current_user.admin? || active_country_id.present?
  end
  helper_method :active_country?


  def active_country_id
    current_user.admin? ? session[:active_country_id] : current_user.country_id
  end
  helper_method :active_country_id

  private

  def accessible_orders
    current_user.
      accessible(Order).
      where(country_id: active_country_id).
      includes :user, :supply
  end

  def accessible_responses
    current_user.
      accessible(Response).
      where(country_id: active_country_id).
      includes :orders => :supply
  end
end
