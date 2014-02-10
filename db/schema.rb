# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140209222506) do

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  add_index "countries", ["code"], name: "index_countries_on_code"

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.string   "email"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "fulfilled_at"
    t.date     "received_at"
    t.integer  "supply_id"
    t.string   "location"
    t.string   "entered_by"
  end

  create_table "responses", force: true do |t|
    t.integer  "order_id"
    t.string   "delivery_method"
    t.string   "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplies", force: true do |t|
    t.string   "shortcode"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supplies", ["shortcode"], name: "index_supplies_on_shortcode"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "pcv_id"
    t.integer  "country_id"
    t.string   "role",                   default: "user"
    t.string   "location"
    t.integer  "pcmo_id"
    t.string   "time_zone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
