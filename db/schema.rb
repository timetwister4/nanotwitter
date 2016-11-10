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

ActiveRecord::Schema.define(version: 9) do

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
  end

  create_table "home_feeds", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tweet_id"
  end

  create_table "mentions", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "user_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "text"
    t.integer  "likes"
    t.boolean  "reply"
    t.integer  "reply_id"
    t.integer  "author_id"
    t.integer  "home_feed_id"
    t.integer  "profile_feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author_name"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "user_name"
    t.string   "email"
    t.string   "password"
    t.integer  "follower_count"
    t.integer  "following_count"
    t.integer  "tweet_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
