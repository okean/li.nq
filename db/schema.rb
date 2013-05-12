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

ActiveRecord::Schema.define(:version => 20130510160513) do

  create_table "links", :force => true do |t|
    t.string   "identifier"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "links", ["identifier"], :name => "index_links_on_identifier"

  create_table "urls", :force => true do |t|
    t.string   "original"
    t.integer  "link_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "urls", ["original"], :name => "index_urls_on_original"

  create_table "visits", :force => true do |t|
    t.string   "ip"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "link_id"
  end

  add_index "visits", ["country"], :name => "index_visits_on_country"
  add_index "visits", ["created_at"], :name => "index_visits_on_created_at"

end
