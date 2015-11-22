class RequestForm < Reform::Form
  property :user
  property :country
  property :entered_by
  property :text

  collection :supplies

  validates :user, presence: true
  validates :country, presence: true
  validates :entered_by, presence: true
  validates :supplies, presence: true
  validate :supplies_are_available

  def initialize *args
    super
    self.country ||= model.submitter.country
  end

  # FIXME: this seems necessary. Figure out why (and submit PR?).
  def self.validators_on name
    validator._validators[name]
  end

  def user= id
    super User.pcv.find_by(id: id)
  end
  def supplies= ids
    super Supply.where(id: ids)
  end

  def save
    super

    model.reload
    mark_duplicated_orders
    update_wait_times
  end

  def users
    country.users.pcv.order(last_name: :asc)
  end

  def available_supplies
    country.supplies
  end

  def success_message
    # FIXME: this due logic is duplicated a lot
    due = model.orders.first.due_at.strftime "%B %d"
    if entered_by == for_volunteer
      I18n.t! "flash.request.placed", expected_receipt_date: due
    else
      I18n.t! "flash.request.placed_for", username: for_volunteer.name, expected_receipt_date: due
    end
  end

  private

  alias_method :for_volunteer, :user

  def supplies_are_available
    unavailable = supplies - available_supplies
    if unavailable.any?
      model.errors.add :supplies, "not available - #{unavailable.map(&:name).to_sentence}"
    end
    if supplies.none?
      model.errors.add :supplies, "are required"
    end
  end

  def mark_duplicated_orders
    for_volunteer.orders.
      where(response: nil, supply: supplies).
      where.not(request: model).
      update_all duplicated_at: model.created_at
  end

  def update_wait_times
    for_volunteer.last_requested_at = model.created_at
    for_volunteer.waiting_since   ||= model.created_at
    for_volunteer.save!
  end
end
