class RePopulateSmsUsers < ActiveRecord::Migration
  def up
    SMS.where(user_id: nil).find_each do |sms|
      user = begin
        Phone.lookup(sms.number).try :user
      rescue ActiveRecord::RecordNotFound
        next
      end
      next unless user

      sms.user_id           = user.id
      sms.twilio_account_id = user.country.twilio_account.id
      sms.save! validate: false # would fail as we are mutating user
    end
  end

  def down
  end
end
