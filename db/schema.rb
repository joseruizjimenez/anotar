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

ActiveRecord::Schema.define(:version => 20120727191457) do

  create_table "hashtags", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.integer  "hits",       :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "hashtags_notes", :id => false, :force => true do |t|
    t.integer "hashtag_id"
    t.integer "note_id"
  end

  add_index "hashtags_notes", ["hashtag_id"], :name => "index_hashtags_notes_on_hashtag_id"
  add_index "hashtags_notes", ["note_id"], :name => "index_hashtags_notes_on_note_id"

  create_table "notes", :force => true do |t|
    t.string   "author_id",  :default => "",    :null => false
    t.string   "title"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "text"
    t.integer  "edit_count", :default => 0
    t.boolean  "shared",     :default => false
    t.boolean  "fav",        :default => false
    t.text     "html_text"
  end

  create_table "session_credentials", :force => true do |t|
    t.string   "author_id",  :default => "", :null => false
    t.string   "session_id", :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "visits",     :default => 0
  end

  add_index "session_credentials", ["author_id"], :name => "index_session_credentials_on_author_id", :unique => true
  add_index "session_credentials", ["session_id"], :name => "index_session_credentials_on_session_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "username",               :default => "",    :null => false
    t.boolean  "opt_in"
    t.string   "author_id",              :default => "",    :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["author_id"], :name => "index_users_on_author_id", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
