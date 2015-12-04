class AddCountryToRosterUploads < ActiveRecord::Migration
  def change
    add_reference :roster_uploads, :country, index: true, foreign_key: true
  end
end
