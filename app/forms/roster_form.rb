class RosterForm < Reform::Form
  property :country

  validate :country

  class RowForm < Reform::Form
    property :email
    property :phone
    property :phone2
    property :first_name
    property :last_name
    property :pcv_id
    property :role
    property :location
    property :time_zone

    validates :email, :first_name, :last_name, :pcv_id, :role, :location, :time_zone, presence: true
  end

  collection :rows, form: RowForm

  def headers
    Roster.headers
  end

  def removed_emails
    model.removed_pcvs.pluck :email
  end

  def valid_emails
    rows.reject { |r| r.errors.any? }.map &:email
  end
end
