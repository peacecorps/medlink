class ResponseRecorder
  def call response
    response.save!
    mark_updated_orders response
    update_wait_times response.user
    try_auto_archive response
  end

  private

  def mark_updated_orders response
    old = response.user.orders.without_responses.
      where(supply: response.supplies)
    if old.exists?
      old.update_all(response_id: response.id)
      response.reload # so that response.orders is correct
    end
  end

  def update_wait_times user
    user.update! waiting_since: user.orders.without_responses.minimum(:created_at)
  end

  def try_auto_archive response
    if response.orders.all? { |o| o.delivery_method.auto_archive? }
      response.update! archived_at: Time.now
    end
  end
end
