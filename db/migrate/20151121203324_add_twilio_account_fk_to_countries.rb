class AddTwilioAccountFkToCountries < ActiveRecord::Migration
  def change
    add_foreign_key :countries, :twilio_accounts
  end
end
