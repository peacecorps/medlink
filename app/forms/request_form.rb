class RequestForm < Reform::Form
  # TODO: rename `user` to something more descriptive
  property :user
  property :country
  property :entered_by
  property :text
  property :message

  collection :supplies

  validates :user, presence: true
  validates :country, presence: true
  validates :entered_by, presence: true
  validates :supplies, presence: true
  validate  :supplies_are_available

  def initialize *args
    super
    self.country ||= model.submitter.country
  end

  def user= id
    super User.pcv.find_by(id: id)
  end
  def supplies= ids
    super Supply.where(id: ids)
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
    if entered_by == user
      I18n.t! "flash.request.placed", expected_receipt_date: due
    else
      I18n.t! "flash.request.placed_for", username: user.name, expected_receipt_date: due
    end
  end

  private

  def supplies_are_available
    unavailable = supplies - available_supplies
    if unavailable.any?
      model.errors.add :supplies, "not available - #{unavailable.map(&:name).to_sentence}"
    end
    if supplies.none?
      model.errors.add :supplies, "are required"
    end
  end
end
