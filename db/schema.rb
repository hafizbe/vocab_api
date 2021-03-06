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

ActiveRecord::Schema.define(version: 20140705134343) do

  create_table "api_keys", force: true do |t|
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.string   "word"
    t.string   "english_m"
    t.integer  "sura_id"
    t.integer  "aya_id"
    t.string   "urdu_m"
    t.integer  "juzz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fr_m"
  end

  add_index "cards", ["sura_id"], name: "index_cards_on_sura_id", using: :btree

  create_table "interrogations", force: true do |t|
    t.integer  "response"
    t.integer  "old_interval"
    t.integer  "next_interval"
    t.date     "next_date"
    t.decimal  "easiness_factor", precision: 10, scale: 0
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "date_response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interrogations", ["card_id", "user_id", "date_response"], name: "Index unique Interrogations", unique: true, using: :btree
  add_index "interrogations", ["card_id", "user_id"], name: "index_interrogations_on_card_id_and_user_id", unique: true, using: :btree
  add_index "interrogations", ["card_id"], name: "index_interrogations_on_card_id", using: :btree
  add_index "interrogations", ["user_id"], name: "index_interrogations_on_user_id", using: :btree

  create_table "suras", force: true do |t|
    t.string   "name_arabic"
    t.string   "name_phonetic"
    t.integer  "nb_cards"
    t.integer  "nb_versets"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
