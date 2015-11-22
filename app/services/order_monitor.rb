class OrderMonitor
  def new_request request
    mark_duplicated_orders request
    update_wait_times request
  end

  def mark_duplicated_orders request
    request.user.orders.
      where(response: nil, supply: request.supplies).
      where.not(request: request).
      update_all duplicated_at: request.created_at
  end

  def update_wait_times request
    user = request.user
    user.last_requested_at = request.created_at
    user.waiting_since   ||= request.created_at
    user.save!
  end
end
