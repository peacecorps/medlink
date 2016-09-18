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
          if e.message =~ /was not found/
            csv << [p.id, p.condensed, nil, e]
          elsif e.message =~ /Bad request/
            puts "Hitting errors ... waiting a minute"
            sleep 60
            retry
          else
            raise
          end
        end
      end
    end
  end

  task :standardize => :environment do
    total = 0
    users = 0

    User.find_each do |user|
      deleted = 0
      selected = {}

      user.phones.each do |phone|
        if replacement = selected[phone.condensed]
          phone.messages.update_all(phone_id: replacement.id)
          phone.delete
          deleted += 1
        else
          selected[phone.condensed] = phone
        end
      end

      if deleted > 0
        total += deleted
        users += 1
      end
    end

    puts "Deleted #{total} phones from #{users} users"
  end
end
