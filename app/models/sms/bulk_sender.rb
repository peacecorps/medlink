class SMS::BulkSender
  include ActiveModel::Model

  attr_accessor :country_ids, :body

  def country_options
    country_ids = User.uniq.pluck :country_id
    countries = Country.where(id: country_ids).order(name: :asc)
    countries.map { |c| ["#{c.name} (#{c.users.count})", c.id] }
  end

  def send!
    raise "No message provided" if body.empty?

    country_ids.reject! &:empty?
    country_ids.each do |country_id|
      CountrySMSJob.perform_later country_id, body
    end

    User.where(country_id: country_ids).count
  end
end
