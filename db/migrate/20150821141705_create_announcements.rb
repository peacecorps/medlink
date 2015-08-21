class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.belongs_to :country, index: true, foreign_key: true
      t.string :message
      t.json :schedule
      t.datetime :last_sent_at

      t.timestamps null: false
    end
  end
end
