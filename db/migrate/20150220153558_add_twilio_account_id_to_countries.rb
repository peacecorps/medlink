class AddTwilioAccountIdToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :twilio_account_id, :integer
  end
end
