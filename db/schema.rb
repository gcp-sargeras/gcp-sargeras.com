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

ActiveRecord::Schema[7.0].define(version: 2022_12_19_193711) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "simc_reports", force: :cascade do |t|
    t.text "options"
    t.text "html_report"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "message_id"
    t.jsonb "json_report", default: "{}", null: false
    t.bigint "requester_id"
    t.bigint "requester_message_id"
    t.text "custom_string"
    t.bigint "requester_channel_id"
    t.string "requester_attachment_url"
    t.bigint "wow_character_id"
    t.index ["wow_character_id"], name: "index_simc_reports_on_wow_character_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "app"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "discord_id"
  end

  create_table "warcraft_logs_characters", force: :cascade do |t|
    t.string "name"
    t.string "klass"
    t.string "sub_klass"
    t.string "server"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "warcraft_logs_fights", force: :cascade do |t|
    t.bigint "warcraft_logs_reports_id"
    t.datetime "start_time", precision: nil
    t.datetime "end_time", precision: nil
    t.integer "boss"
    t.string "name"
    t.integer "size"
    t.integer "difficulty"
    t.boolean "kill"
    t.integer "partial"
    t.integer "bossPercentage"
    t.integer "fightPercentage"
    t.integer "lastPhaseForPercentageDisplay"
    t.datetime "created_at", default: "2020-12-06 17:57:00", null: false
    t.datetime "updated_at", default: "2020-12-06 17:57:00", null: false
    t.index ["warcraft_logs_reports_id"], name: "index_warcraft_logs_fights_on_warcraft_logs_reports_id"
  end

  create_table "warcraft_logs_reports", id: :string, force: :cascade do |t|
    t.string "title"
    t.string "owner"
    t.datetime "start", precision: nil
    t.datetime "end", precision: nil
    t.string "zone"
    t.datetime "created_at", default: "2020-12-06 17:57:00", null: false
    t.datetime "updated_at", default: "2020-12-06 17:57:00", null: false
    t.index ["id"], name: "index_warcraft_logs_reports_on_id"
    t.index ["owner"], name: "index_warcraft_logs_reports_on_owner"
  end

  create_table "wow_characters", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "wow_server_id", null: false
    t.bigint "wow_region_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wow_region_id"], name: "index_wow_characters_on_wow_region_id"
    t.index ["wow_server_id"], name: "index_wow_characters_on_wow_server_id"
  end

  create_table "wow_regions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wow_servers", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "simc_reports", "wow_characters"
  add_foreign_key "wow_characters", "wow_regions"
  add_foreign_key "wow_characters", "wow_servers"
end
