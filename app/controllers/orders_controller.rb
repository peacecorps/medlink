class OrdersController < ApplicationController
  def index
    @orders = accessible_orders.order created_at: :desc
  end

  def manage
    authorize! :respond, User
    @orders    = accessible_orders
    @responses = accessible_responses
  end

  def active_country?
    !current_user.admin? || active_country_id.present?
  end
  helper_method :active_country?

  private

  def active_country_id
    current_user.admin? ? session[:active_country_id] : current_user.country_id
  end

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
