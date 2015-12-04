class CreateRosterUploads < ActiveRecord::Migration
  def change
    create_table :roster_uploads do |t|
      t.belongs_to :uploader, index: true
      t.string :uri
      t.text :body

      t.timestamps null: false
    end

    add_foreign_key :roster_uploads, :users, column: :uploader_id
  end
end
