class PopulateMessagePhones < ActiveRecord::Migration
  def change
    default_twilio_account = TwilioAccount.first
    SMS.where(twilio_account_id: nil).update_all twilio_account_id: default_twilio_account.id

    phones = Phone.all.each_with_object({}) do |p, h|
      h[p.condensed] = p
    end

    SMS.find_each do |m|
      condensed = Phone.condense m.number
      phones[condensed] ||= Phone.create!(number: m.number, condensed: condensed)

      p = phones[condensed]
      m.phone = p
      m.save!
    end
  end
end
