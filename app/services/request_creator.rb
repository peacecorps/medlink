class RequestCreator
  attr_reader :ordered_by, :request, :error_message

  def initialize ordered_by, params
    @ordered_by = ordered_by
    @start_time = Time.now
    @request    = build_request params
  end

  def save
    if request.orders.any?
      request.save!
      mark_duplicated_orders
      update_waiting_since
      true
    else
      @error_message = I18n.t! "flash.request.empty"
      false
    end
  end

  def success_message
    due = request.orders.first.due_at.strftime "%B %d"
    if ordered_by == request.user
      I18n.t! "flash.request.placed", expected_receipt_date: due
    else
      I18n.t! "flash.request.placed_for", username: request.user.name, expected_receipt_date: due
    end
  end

private

  def order_params params
    # [ { supply_id: # }, { supply_id: # } ], in either case
    @_order_params ||= if supplies = params.delete(:supplies)
      supplies.map { |s| { supply_id: s.id } }
    else
      params[:request].delete(:orders_attributes).values
    end
  end

  def build_request params
    orders = order_params params

    r = Request.new safe params
    r.entered_by = ordered_by.id
    r.country_id = r.user.country_id

    orders.each do |order|
      r.orders.new(
        request:    r,
        user:       r.user,
        country_id: r.user.country_id,
        supply_id:  order[:supply_id]
      ) if order[:supply_id].present?
    end

    r
  end

  def safe params
    ActionController::Parameters.new(params).require(:request).permit \
      :user_id, :text, :reorder_of_id
  end

  def mark_duplicated_orders
    request.user.orders.without_responses.group_by(&:supply_id).each do |_, orders|
      mark_all_but_newest_as_duplicate orders
    end
  end

  def mark_all_but_newest_as_duplicate orders
    orders.sort_by(&:created_at).slice(0..-2).each do |order|
      order.update duplicated_at: @start_time
    end
  end

  def update_waiting_since
    request.user.update!(
      waiting_since:     request.user.orders.without_responses.minimum(:created_at),
      last_requested_at: @start_time
    )
  end
end
