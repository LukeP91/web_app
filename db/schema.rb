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

ActiveRecord::Schema.define(version: 20170831120513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string  "name",            null: false
    t.integer "organization_id", null: false
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "hash_tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "interests", force: :cascade do |t|
    t.string   "name",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "category_id"
    t.integer  "organization_id", null: false
    t.index ["name"], name: "index_interests_on_name", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name",      null: false
    t.string "subdomain", null: false
    t.index ["name"], name: "index_organizations_on_name", using: :btree
    t.index ["subdomain"], name: "index_organizations_on_subdomain", using: :btree
  end

  create_table "sources", force: :cascade do |t|
    t.string  "name"
    t.integer "organization_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.string "user_name"
    t.string "message"
    t.string "tweet_id",  null: false
  end

  create_table "tweets_hash_tags", force: :cascade do |t|
    t.integer "tweet_id",    null: false
    t.integer "hash_tag_id", null: false
    t.index ["hash_tag_id"], name: "index_tweets_hash_tags_on_hash_tag_id", using: :btree
    t.index ["tweet_id"], name: "index_tweets_hash_tags_on_tweet_id", using: :btree
  end

  create_table "tweets_sources", force: :cascade do |t|
    t.integer "tweet_id"
    t.integer "source_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "age"
    t.boolean  "admin",                  default: false, null: false
    t.integer  "organization_id",        default: 1,     null: false
    t.string   "mobile_phone"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_interests", force: :cascade do |t|
    t.integer "user_id"
    t.integer "interest_id"
    t.index ["interest_id"], name: "index_users_interests_on_interest_id", using: :btree
    t.index ["user_id"], name: "index_users_interests_on_user_id", using: :btree
  end

end
