# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_11_160557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.integer "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["space_id"], name: "index_connections_on_space_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "url"
    t.string "medium"
    t.string "name"
    t.string "text_content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
    t.string "mp3_url"
    t.string "audio_timestamp"
    t.string "audio_duration"
    t.string "status", default: "not started"
  end

  create_table "items_shelves", id: false, force: :cascade do |t|
    t.bigint "shelf_id", null: false
    t.bigint "item_id", null: false
  end

  create_table "items_spaces", id: false, force: :cascade do |t|
    t.bigint "space_id", null: false
    t.bigint "item_id", null: false
  end

  create_table "shelves", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.string "username"
    t.index ["user_id"], name: "index_shelves_on_user_id"
  end

  create_table "shelves_spaces", id: false, force: :cascade do |t|
    t.bigint "shelf_id", null: false
    t.bigint "space_id", null: false
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "telegram_hash"
    t.string "telegram_chat_id"
    t.string "username", limit: 30, null: false
    t.string "phone_number"
    t.string "chrome_auth_token"
    t.boolean "admin", default: false, null: false
    t.float "tts_balance_in_min"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhook_events", force: :cascade do |t|
    t.string "source"
    t.string "external_id"
    t.json "data"
    t.integer "state", default: 0
    t.text "processing_errors"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["external_id"], name: "index_webhook_events_on_external_id"
    t.index ["source", "external_id"], name: "index_webhook_events_on_source_and_external_id"
    t.index ["source"], name: "index_webhook_events_on_source"
  end

  add_foreign_key "connections", "spaces"
  add_foreign_key "shelves", "users"
end
