class CreateEncryptChallenges < ActiveRecord::Migration
  def change
    create_table :encrypt_challenges do |t|
      t.string :pre, null: false, index: true
      t.string :post, null: false

      t.timestamps null: false
    end
  end
end
