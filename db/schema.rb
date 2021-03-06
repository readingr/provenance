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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130423134643) do

  create_table "Users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "prov_access_token"
    t.string   "prov_username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "data_provider_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "data_provider_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "access_token"
    t.string   "update_frequency"
    t.string   "oauth_token_secret"
    t.string   "uid"
  end

  create_table "data_providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "downloaded_data", :force => true do |t|
    t.string   "name"
    t.text     "data"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "data_provider_user_id"
    t.integer  "prov_id"
  end

  create_table "reports", :force => true do |t|
    t.string   "student_first_name"
    t.string   "student_last_name"
    t.string   "content"
    t.string   "subject"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
