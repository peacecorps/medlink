class RequestPlacer
  attr_reader :request, :supplies

  include ActiveModel::Model
  def self.model_name
    ActiveModel::Name.new Request
  end
  validates_presence_of :for_volunteer_id, :supplies
  validate :supplies_are_available

  def for_volunteer_id
    request.user_id
  end
  def text
    request.text
  end
  def supply_ids
    supplies.pluck :id
  end

  def initialize placed_by:, for_volunteer_id: nil, supply_ids: [], message: "", sms: nil
    @placed_by = placed_by
    @request   = Request.new entered_by: @placed_by.id

    @request.text    = message
    @request.message = sms
    @request.user = if placed_by.pcv?
      placed_by
    elsif for_volunteer_id
      User.find_by id: for_volunteer_id
    end

    @request.country = @request.user.country if @request.user

    @supplies = Supply.where id: supply_ids
  end

  def save
    return false unless valid?

    save_request
    mark_duplicated_orders
    update_wait_times
    return true
  end

  def users
    country.users.pcv.order(last_name: :asc)
  end

  def available_supplies
    country.supplies
  end

  def success_message
    # FIXME: this due logic is duplicated a lot
    due = request.orders.first.due_at.strftime "%B %d"
    if placed_by == for_volunteer
      I18n.t! "flash.request.placed", expected_receipt_date: due
    else
      I18n.t! "flash.request.placed_for", username: for_volunteer.name, expected_receipt_date: due
    end
  end

  private

  attr_reader :placed_by

  def country
    placed_by.country
  end

  def for_volunteer
    request.user
  end

  def supplies_are_available
    unavailable = supplies - available_supplies
    if unavailable.any?
      errors.add :supplies, "not available - #{unavailable.map(&:name).to_sentence}"
    end
  end

  def save_request
    request.save!
    request.message.update request: request if request.message
    supplies.each { |s| request.orders.create! user: for_volunteer, country_id: for_volunteer.country_id, supply: s }
  end

  def mark_duplicated_orders
    for_volunteer.orders.
      where(response: nil, supply: supplies).
      where.not(request: request).
      update_all duplicated_at: request.created_at
  end

  def update_wait_times
    for_volunteer.last_requested_at = request.created_at
    for_volunteer.waiting_since   ||= request.created_at
    for_volunteer.save!
  end
end
