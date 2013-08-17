class ReportController < ApplicationController
  def request_history
    @orders = current_user.accessible_orders
  end

  def fulfillment_history
  end

  def recent_adds
    @user
  end

  def recent_edits
  end

  def pcmo_response_times
  end

  def supply_history
  end
end
