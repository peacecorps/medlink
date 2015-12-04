namespace :phones do
  task :validate => :environment do
    require "csv"

    twilio = TwilioAccount.first!
    client = Twilio::REST::LookupsClient.new twilio.sid, twilio.auth

    path = Rails.root.join "phones.csv"
    puts "Writing report to #{path}"
    CSV.open path, "w" do |csv|
      csv << ["id", "current number", "found number", "error"]
      Phone.find_each do |p|
        begin
          found = client.phone_numbers.get p.number
          found.phone_number.present?
          csv << [p.id, p.condensed, found.phone_number, nil]
        rescue Twilio::REST::RequestError => e
          csv << [p.id, p.condensed, nil, e]
        end
      end
    end
  end
end
