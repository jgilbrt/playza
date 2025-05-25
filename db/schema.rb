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

ActiveRecord::Schema[7.1].define(version: 2025_05_25_131004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "awards", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.string "award_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_awards_on_match_id"
    t.index ["user_id"], name: "index_awards_on_user_id"
  end

  create_table "match_players", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "user_id", null: false
    t.string "status"
    t.string "role"
    t.integer "goals_scored"
    t.integer "assists"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.index ["match_id"], name: "index_match_players_on_match_id"
    t.index ["team_id"], name: "index_match_players_on_team_id"
    t.index ["user_id"], name: "index_match_players_on_user_id"
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "opponent_name"
    t.datetime "date"
    t.string "location"
    t.integer "score_own"
    t.integer "score_opponent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "season"
    t.boolean "has_happened"
    t.integer "lineup_starters", default: [], array: true
    t.integer "lineup_substitutes", default: [], array: true
    t.bigint "dick_of_the_day_player_id"
    t.string "dotd_punishment"
    t.index ["team_id"], name: "index_matches_on_team_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.string "status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id", null: false
    t.index ["team_id"], name: "index_payments_on_team_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.bigint "team_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "awards", "matches"
  add_foreign_key "awards", "users"
  add_foreign_key "match_players", "matches"
  add_foreign_key "match_players", "teams"
  add_foreign_key "match_players", "users"
  add_foreign_key "matches", "teams"
  add_foreign_key "payments", "teams"
  add_foreign_key "payments", "users"
  add_foreign_key "users", "teams"
end
