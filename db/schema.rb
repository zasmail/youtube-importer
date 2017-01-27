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

ActiveRecord::Schema.define(version: 20170127152401) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "channels", force: :cascade do |t|
    t.integer  "talks_id"
    t.integer  "playlist_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "name"
    t.string   "url"
    t.datetime "last_updated"
    t.string   "slug"
    t.index ["playlist_id"], name: "index_channels_on_playlist_id"
    t.index ["talks_id"], name: "index_channels_on_talks_id"
  end

  create_table "fb_tokens", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires"
  end

  create_table "playlists", force: :cascade do |t|
    t.string   "objectID"
    t.string   "slug"
    t.string   "name"
    t.string   "description"
    t.datetime "published_at"
    t.integer  "popularity_score"
    t.integer  "unpopular_score"
    t.integer  "facebook_share_count"
    t.integer  "facebook_comment_count"
    t.boolean  "is_english"
    t.integer  "google_share_count"
    t.integer  "reddit_share_count"
    t.integer  "linkedin_share_count"
    t.integer  "pinterest_share_count"
    t.integer  "total_share_count"
    t.boolean  "has_description"
    t.boolean  "has_tags"
    t.integer  "like_count"
    t.integer  "dislike_count"
    t.string   "image_url"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "tags",                   default: "--- []\n"
    t.integer  "talks_id"
    t.string   "channel_name"
    t.boolean  "hd_image"
    t.string   "url"
    t.string   "object_id"
    t.datetime "date"
    t.text     "languages"
    t.index ["talks_id"], name: "index_playlists_on_talks_id"
  end

  create_table "talks", force: :cascade do |t|
    t.string   "object_id"
    t.string   "name"
    t.string   "description"
    t.datetime "date"
    t.integer  "duration_range"
    t.integer  "viewed_count"
    t.integer  "like_count"
    t.integer  "dislike_count"
    t.string   "event_name"
    t.string   "languages"
    t.integer  "popularity_score"
    t.integer  "unpopular_score"
    t.integer  "facebook_share_count"
    t.integer  "facebook_comment_count"
    t.boolean  "is_english"
    t.integer  "google_share_count"
    t.integer  "reddit_share_count"
    t.integer  "linkedin_share_count"
    t.integer  "pinterest_share_count"
    t.integer  "total_share_count"
    t.boolean  "has_description"
    t.boolean  "has_tags"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "tags",                   default: "--- []\n"
    t.text     "speakers",               default: "--- []\n"
    t.string   "image_url"
    t.string   "hd_image"
    t.string   "url"
    t.integer  "playlist_id"
    t.index ["object_id"], name: "index_talks_on_object_id"
    t.index ["playlist_id"], name: "index_talks_on_playlist_id"
  end

end
