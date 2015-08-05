class RequestCreator
  attr_reader :user, :request, :error_message

  def initialize user, params
    @user       = user
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
    if user == request.user
      I18n.t! "flash.request.placed"
    else
      I18n.t! "flash.request.placed_for", username: request.user.name
    end
  end

private

  def build_request params
    # [ { supply_id: # }, { supply_id: # } ], in either case
    orders = params.delete(:orders) || params[:request].delete(:orders_attributes).values

    r = Request.new safe params
    r.entered_by = user.id
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
    ActionController::Parameters.new(params).require(:request).permit :user_id, :text
  end

  def mark_duplicated_orders
    user.orders.without_responses.group_by(&:supply_id).each do |_, orders|
      mark_all_but_newest_as_duplicate orders
    end
  end

  def mark_all_but_newest_as_duplicate orders
    orders.sort_by(&:created_at).slice(0..-2).each do |order|
      order.update duplicated_at: @start_time
    end
  end

  def update_waiting_since
    user.update_attributes(
      waiting_since:     user.orders.without_responses.minimum(:created_at),
      last_requested_at: @start_time
    )
  end
end
