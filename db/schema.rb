# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 5) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password",   :limit => 100
    t.string   "email",      :limit => 100
    t.boolean  "active",                    :default => true
    t.integer  "posts",                     :default => 0
    t.string   "username",   :limit => 100
    t.integer  "admin",      :limit => 3,   :default => 0
  end

  add_index "accounts", ["username"], :name => "username", :unique => true

  create_table "posts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title"
    t.text     "link"
    t.string   "link_t",     :limit => 100
    t.string   "tag"
    t.text     "text"
    t.integer  "uid"
    t.integer  "vote",                      :default => 1
    t.integer  "znum",                      :default => 0
    t.boolean  "active",                    :default => true
    t.string   "username",   :limit => 50
    t.integer  "replys",     :limit => 6,   :default => 0
    t.integer  "hits",       :limit => 6,   :default => 0
  end

  create_table "rankings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cids"
  end

  create_table "replies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voterecords", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "votetype",   :limit => 10
    t.integer  "cid"
    t.integer  "uid"
  end

end
