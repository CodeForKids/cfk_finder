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

ActiveRecord::Schema.define(version: 20141225183900) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "action"
    t.string   "ip_address"
    t.text     "parameters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "addresses", force: true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "province"
    t.string   "country"
    t.string   "postal_code"
    t.float    "latitude",    limit: 24
    t.float    "longitude",   limit: 24
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "spots_available",                          default: 3
    t.string   "event_type"
    t.text     "materials_needed"
    t.integer  "address_id"
    t.integer  "price_cents",                              default: 0,     null: false
    t.string   "price_currency",                           default: "CAD", null: false
    t.decimal  "tax_rate",         precision: 8, scale: 2
    t.integer  "subject_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["address_id"], name: "index_events_on_address_id", using: :btree
  add_index "events", ["subject_id"], name: "index_events_on_subject_id", using: :btree

  create_table "kids", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.date     "date_of_birth"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parents", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tutors", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.integer  "max_students"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "role_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
