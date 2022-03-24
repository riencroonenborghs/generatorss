# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_03_15_075918) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "filters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "comparison"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_filters_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "plan_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0
    t.string "token"
    t.string "charge_id"
    t.string "error_message"
    t.string "customer_id"
    t.integer "payment_gateway"
    t.integer "price_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_orders_on_plan_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name", null: false
    t.string "stripe_plan_name", null: false
    t.integer "price_cents", null: false
    t.integer "max_subscriptions", default: 3, null: false
    t.integer "posts_per_subscription", default: 5, null: false
    t.integer "refresh_after_minutes", default: 1440, null: false
    t.integer "clean_after_days", default: 7, null: false
    t.integer "filter_rules", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_items", force: :cascade do |t|
    t.string "itemable_type", null: false
    t.bigint "itemable_id", null: false
    t.string "title", null: false
    t.string "link", null: false
    t.datetime "published_at", null: false
    t.text "description"
    t.string "guid", null: false
    t.string "media_title"
    t.string "media_url"
    t.string "media_type"
    t.integer "media_width"
    t.integer "media_height"
    t.string "media_thumbnail_url"
    t.integer "media_thumbnail_width"
    t.integer "media_thumbnail_height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["itemable_type", "itemable_id"], name: "index_rss_items_on_itemable"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subscriptable_type", null: false
    t.bigint "subscriptable_id", null: false
    t.boolean "active", default: true, null: false
    t.text "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_subscriptions_on_active"
    t.index ["subscriptable_type", "subscriptable_id"], name: "index_subscriptions_on_subscriptable"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tweets", force: :cascade do |t|
    t.bigint "twitter_user_id", null: false
    t.string "tweet_id", null: false
    t.text "text", null: false
    t.text "title", null: false
    t.datetime "tweeted_at", null: false
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id"], name: "index_tweets_on_tweet_id"
    t.index ["tweeted_at"], name: "index_tweets_on_tweeted_at"
    t.index ["twitter_user_id"], name: "index_tweets_on_twitter_user_id"
  end

  create_table "twitter_users", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "twitter_id", null: false
    t.string "name", null: false
    t.string "username", null: false
    t.string "description"
    t.string "profile_image_url"
    t.string "url"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twitter_id"], name: "index_twitter_users_on_twitter_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "uuid", null: false
    t.string "stripe_customer_id"
    t.string "stripe_subscription_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
    t.index ["stripe_subscription_id"], name: "index_users_on_stripe_subscription_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "youtube_channels", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "url", null: false
    t.string "rss_url", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "youtube_rss_entries", force: :cascade do |t|
    t.bigint "youtube_channel_id", null: false
    t.datetime "published_at", null: false
    t.string "entry_id", null: false
    t.json "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["youtube_channel_id"], name: "index_youtube_rss_entries_on_youtube_channel_id"
  end

  add_foreign_key "filters", "users"
  add_foreign_key "orders", "plans"
  add_foreign_key "orders", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tweets", "twitter_users"
  add_foreign_key "youtube_rss_entries", "youtube_channels"
end
