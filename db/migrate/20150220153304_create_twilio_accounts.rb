class CreateTwilioAccounts < ActiveRecord::Migration
  def change
    create_table :twilio_accounts do |t|
      t.string :sid
      t.string :auth
      t.string :number

      t.timestamps
    end
  end
end
