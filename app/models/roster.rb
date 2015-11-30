class Roster
  UnrecognizedHeader = Class.new StandardError

  include ActiveModel::Model
  include Virtus.model
  attribute :country
  attribute :rows

  def self.headers
    %w(email phone phone2 first_name last_name pcv_id role location time_zone)
  end

  def self.from_csv csv, country:
    rows = CSV.parse csv.strip, headers: true, converters: ->(f) { f ? f.strip : nil }
    unrecognized = rows.headers - headers
    raise UnrecognizedHeader, unrecognized.to_sentence if unrecognized.any?
    new country: country, rows: rows.map { |r| Row.new r.to_hash }
  end

  class Row
    include Virtus.model
    Roster.headers.each do |header|
      attribute header
    end

    def persisted?; end
    def save; end

    def user_hash
      {
        email:      email,
        first_name: first_name,
        last_name:  last_name,
        pcv_id:     pcv_id,
        role:       role,
        location:   location,
        time_zone:  time_zone
      }
    end

    def phone_hashes
      [phone, phone2].select(&:present?).map { |number| { number: number } }
    end
  end

  def persisted?; end
  def inspect; "Roster(#{country.name}: #{rows.count} rows)"; end

  def save
    # TODO: this clobbers user edits. Do we need to allow PCVs to edit?
    import_new_users
    update_existing_users
    inactivate_removed_pcvs
    true
  end

  def removed_pcvs
    country.users.pcv.where(email: removed_emails.to_a)
  end

  def active_emails
    rows.map &:email
  end

  private

  def new_rows
    rows.reject { |row| existing_users.include? row.email  }
  end

  def existing_rows
    rows.select { |row| existing_users.include? row.email }
  end

  def import_new_users
    new_rows.each do |row|
      user = country.users.create! row.user_hash.merge password: Devise.friendly_token
      row.phone_hashes.each { |data| user.phones.create! data }
      user
    end
  end

  def update_existing_users
    existing_rows.each do |row|
      user = existing_users.fetch row.email
      user.update! row.user_hash
      row.phone_hashes.each { |data| user.phones.first_or_create! data }
    end
  end

  def inactivate_removed_pcvs
    removed_pcvs.update_all active: false
  end

  def existing_users
    @_existing_users ||= country.users.map { |user| [user.email, user] }.to_h
  end

  def removed_emails
    existing_users.keys - active_emails
  end
end
