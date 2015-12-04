class RequestForm < Reform::Form
  # TODO: rename `user` to something more descriptive
  property :user
  property :country
  property :entered_by
  property :text
  property :message

  property :supplies, virtual: true

  validates :user, presence: true
  validates :country, presence: true
  validates :entered_by, presence: true
  validate  :supplies_are_available

  def initialize *args
    super
    self.country  ||= model.submitter.country
    self.supplies ||= []
  end

  def user= id
    super User.pcv.find_by(id: id)
  end
  def user_id
    user.id
  end
  def supplies= ids
    super Supply.where(id: ids)
  end

  def users
    country.users.pcv.order(last_name: :asc)
  end

  def available_supplies
    country.available_supplies
  end

  def save
    attach_supplies
    super
    mark_duplicated_orders
    update_wait_times
  end

  def success_message
    if entered_by == user.id
      I18n.t! "flash.request.placed", expected_receipt_date: DueDate.new(model)
    else
      I18n.t! "flash.request.placed_for", username: user.name, expected_receipt_date: DueDate.new(model)
    end
  end

  private

  def supplies_are_available
    unavailable = supplies - available_supplies
    if unavailable.any?
      errors.add :supplies, "not available - #{unavailable.map(&:name).to_sentence}"
    end
    if supplies.none?
      errors.add :supplies, "are required"
    end
  end

  def attach_supplies
    supplies.each do |s|
      model.orders.new user: user, supply: s
    end
  end

  def mark_duplicated_orders
    user.orders.
      where(response: nil, supply: model.supplies).
      where.not(request: model).
      update_all duplicated_at: model.created_at
  end

  def update_wait_times
    user.last_requested_at = model.created_at
    user.waiting_since   ||= model.created_at
    user.save!
  end
end
