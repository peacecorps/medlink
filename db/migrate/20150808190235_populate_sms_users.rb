class PopulateSmsUsers < ActiveRecord::Migration
  def up
    SMS.find_each do |sms|
      user = begin
        Phone.lookup(sms.number).try :user
      rescue ActiveRecord::RecordNotFound
        next
      end
      next unless user
      sms.update user_id: user.id, twilio_account_id: user.country.twilio_account.id
    end
  end

  def down
  end
end
