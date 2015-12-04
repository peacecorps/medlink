class AddSecretKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :secret_key, :string
  end
end
