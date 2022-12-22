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

ActiveRecord::Schema[7.0].define(version: 2022_11_05_044745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discord_channels", force: :cascade do |t|
    t.string "channel_id", null: false
    t.string "guild_id", null: false
    t.string "name", null: false
    t.string "description"
    t.datetime "last_loaded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_discord_channels_on_channel_id"
    t.index ["last_loaded"], name: "index_discord_channels_on_last_loaded"
  end

  create_table "filters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "comparison"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "value"], name: "index_filters_on_user_id_and_value"
    t.index ["user_id"], name: "index_filters_on_user_id"
  end

  create_table "itunes_podcasts", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "podcast_id", null: false
    t.string "url", null: false
    t.string "rss_url", null: false
    t.string "name", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["podcast_id"], name: "index_itunes_podcasts_on_podcast_id"
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
    t.integer "enclosure_length"
    t.string "enclosure_type"
    t.string "enclosure_url"
    t.string "itunes_duration"
    t.string "itunes_episode_type"
    t.string "itunes_author"
    t.boolean "itunes_explicit"
    t.string "itunes_image"
    t.string "itunes_title"
    t.string "itunes_summary"
    t.index ["itemable_id"], name: "index_rss_items_on_itemable_id"
    t.index ["itemable_type", "itemable_id"], name: "index_rss_items_on_itemable"
    t.index ["itemable_type", "itemable_id"], name: "index_rss_items_on_itemable_type_and_itemable_id"
    t.index ["itemable_type"], name: "index_rss_items_on_itemable_type"
    t.index ["published_at"], name: "index_rss_items_on_published_at"
  end

  create_table "subreddits", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "url", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_loaded"], name: "index_subreddits_on_last_loaded"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subscriptable_type", null: false
    t.bigint "subscriptable_id", null: false
    t.text "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscriptable_id"], name: "index_subscriptions_on_subscriptable_id"
    t.index ["subscriptable_type", "subscriptable_id"], name: "index_subscriptions_on_subscriptable"
    t.index ["subscriptable_type", "subscriptable_id"], name: "index_subscriptions_on_subscriptable_type_and_subscriptable_id"
    t.index ["subscriptable_type"], name: "index_subscriptions_on_subscriptable_type"
    t.index ["user_id", "subscriptable_type", "subscriptable_id"], name: "sub_user_full_subscriptable"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.index ["uuid"], name: "index_subscriptions_on_uuid"
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
    t.index ["last_loaded"], name: "index_twitter_users_on_last_loaded"
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "websites", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "url"
    t.string "rss_url"
    t.string "name"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_loaded"], name: "index_websites_on_last_loaded"
    t.index ["rss_url"], name: "index_websites_on_rss_url"
  end

  create_table "youtube_channels", force: :cascade do |t|
    t.datetime "last_loaded"
    t.string "url", null: false
    t.string "rss_url", null: false
    t.string "name", null: false
    t.string "image_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_loaded"], name: "index_youtube_channels_on_last_loaded"
    t.index ["rss_url"], name: "index_youtube_channels_on_rss_url"
  end

  create_table "youtube_rss_entries", force: :cascade do |t|
    t.bigint "youtube_channel_id", null: false
    t.datetime "published_at", null: false
    t.string "entry_id", null: false
    t.json "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_youtube_rss_entries_on_entry_id"
    t.index ["published_at"], name: "index_youtube_rss_entries_on_published_at"
    t.index ["youtube_channel_id"], name: "index_youtube_rss_entries_on_youtube_channel_id"
  end

  add_foreign_key "filters", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "tweets", "twitter_users"
  add_foreign_key "youtube_rss_entries", "youtube_channels"
end
