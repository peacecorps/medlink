require 'csv'

def log msg
  puts msg
  Rails.logger.info msg
end

log "Creating intial records from seed data:"

supplies = []
CSV.read(Rails.root+"db/supply.csv").each do |name, shortcode|
  supplies.push [NamedSeeds.identify(shortcode), shortcode, name]
end
Supply.import [:id, :shortcode, :name], supplies, validate: false
log " => Loaded #{Supply.count} supplies"


twilio = TwilioAccount.create! sid: "5555", number: "+15005550006"

tzs = {}
CSV.read(Rails.root.join "db/timezones.csv").each do |country, zone, offset|
  tzs[country] = zone
end

countries = []
File.read(Rails.root.join "db/country.csv").each_line do |name|
  name.strip!
  tz = tzs.fetch name
  countries.push [NamedSeeds.identify(name), name, tz, twilio.id]
end
Country.import [:id, :name, :time_zone, :twilio_account_id], countries, validate: false
log " => Loaded #{Country.count} countries"


supplies  = Supply.all
countries = Country.all
all_pairs = countries.product(supplies).map { |c,s| [c.id, s.id] }
CountrySupply.import [:country_id, :supply_id], all_pairs, validate: false
log " => Created #{CountrySupply.count} country supplies"


log "Please run `rake admin:create` if you would like to make an admin account"
