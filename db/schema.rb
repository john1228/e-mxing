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

ActiveRecord::Schema.define(version: 20150407091139) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "activities", force: :cascade do |t|
    t.string   "title"
    t.string   "cover"
    t.string   "address"
    t.string   "time"
    t.string   "url"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "ads", force: :cascade do |t|
    t.string "image",     limit: 255
    t.string "url",       limit: 255
    t.date   "from_date"
    t.date   "end_date"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.string "url"
    t.date   "start_date"
    t.date   "end_date"
  end

  create_table "captchas", force: :cascade do |t|
    t.string   "mobile"
    t.string   "captcha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "dynamic_comments", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.integer  "user_id"
    t.string   "content",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dynamic_films", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.string   "cover",      limit: 255
    t.string   "film",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "dynamic_images", force: :cascade do |t|
    t.integer  "dynamic_id"
    t.string   "image",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "width"
    t.integer  "height"
  end

  create_table "dynamics", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "top",        default: 0
  end

  create_table "group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "tag"
    t.string   "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_photos", force: :cascade do |t|
    t.integer  "group_id"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_places", force: :cascade do |t|
    t.integer   "group_id"
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "group_places", ["lonlat"], name: "index_group_places_on_lonlat", using: :gist

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "interests"
    t.text     "intro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "like_type"
    t.integer  "user_id"
    t.integer  "liked_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "news", force: :cascade do |t|
    t.string   "title"
    t.string   "cover"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "photo",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loc"
  end

  create_table "places", force: :cascade do |t|
    t.integer   "user_id"
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "places", ["lonlat"], name: "index_places_on_lonlat", using: :gist

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string  "signature",     limit: 255, default: ""
    t.string  "name",          limit: 255, default: ""
    t.string  "avatar",        limit: 255, default: ""
    t.integer "gender",                    default: 0
    t.integer "identity",                  default: 0
    t.date    "birthday",                  default: '1999-03-20'
    t.string  "address",       limit: 255, default: ""
    t.string  "target",        limit: 255, default: ""
    t.string  "skill",         limit: 255, default: ""
    t.string  "often_stadium", limit: 255, default: ""
    t.string  "interests",     limit: 255, default: ""
    t.string  "mobile",        limit: 255, default: ""
  end

  create_table "service_members", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "showtimes", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title",      limit: 255
    t.string   "cover",      limit: 255
    t.string   "film",       limit: 255
    t.string   "intro",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "track_type"
    t.datetime "start"
    t.string   "during"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "intro"
    t.string   "address"
    t.integer  "places"
    t.integer  "free_places", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.string   "password",   limit: 255
    t.string   "salt",       limit: 255
    t.string   "token",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
