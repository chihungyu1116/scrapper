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

ActiveRecord::Schema.define(version: 20130708042502) do

  create_table "links", force: true do |t|
    t.string   "href"
    t.boolean  "visited"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "failed"
    t.string   "domain"
    t.boolean  "crawled"
    t.integer  "merchant_id"
  end

  create_table "merchants", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "category"
    t.string   "phone"
    t.string   "website"
    t.string   "parking"
    t.string   "attire"
    t.string   "good_for_meal"
    t.string   "hours"
    t.string   "music"
    t.string   "best_nights"
    t.string   "noise_level"
    t.string   "ambience"
    t.float    "price_range"
    t.float    "rating"
    t.integer  "health_score"
    t.string   "wifi"
    t.string   "allow_dog"
    t.string   "catering"
    t.string   "has_tv"
    t.string   "good_for_dancing"
    t.string   "alcohol"
    t.string   "wheelchair_accessible"
    t.string   "good_for_group"
    t.string   "good_for_kids"
    t.string   "accept_credit_card"
    t.string   "take_reservation"
    t.string   "delivery"
    t.string   "takeout"
    t.string   "waiter_service"
    t.string   "happy_hours"
    t.string   "smoking"
    t.string   "coat_check"
    t.string   "outdoor_seating"
    t.text     "reviews"
    t.text     "html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "href"
    t.boolean  "failed"
    t.boolean  "completed"
    t.string   "latlon"
  end

end
