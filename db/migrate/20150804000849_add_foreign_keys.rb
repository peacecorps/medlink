class AddForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :country_supplies, :countries
    add_foreign_key :country_supplies, :supplies
    add_foreign_key :orders, :supplies
    add_foreign_key :orders, :requests
    add_foreign_key :phones, :users
    add_foreign_key :requests, :countries
    add_foreign_key :requests, :users
    add_foreign_key :requests, :messages
    add_foreign_key :responses, :countries
    add_foreign_key :responses, :users
    add_foreign_key :responses, :messages
  end
end
