class MessageSender
  include ActiveModel::Model

  attr_accessor :country_ids, :body

  def country_options
    country_ids = User.uniq.pluck :country_id
    countries = Country.where(id: country_ids).order(name: :asc)
    countries.map { |c| ["#{c.name} (#{c.users.count})", c.id] }
  end

  def send!
    raise "No message provided" if body.empty?

    users = User.where(country_id: country_ids)
    users.each do |user|
      SMSJob.perform_later user, body
    end
    users.count
  end
end
