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

ActiveRecord::Schema[8.1].define(version: 2026_03_29_112646) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "badges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "name", null: false
    t.string "trigger", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quest_prerequisites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "prerequisite_id", null: false
    t.bigint "quest_id", null: false
    t.datetime "updated_at", null: false
    t.index ["prerequisite_id"], name: "index_quest_prerequisites_on_prerequisite_id"
    t.index ["quest_id"], name: "index_quest_prerequisites_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.string "canton"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "difficulty", default: 0, null: false
    t.string "estimated_duration"
    t.string "external_url"
    t.integer "priority", default: 0, null: false
    t.text "tips"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "xp_reward", default: 0, null: false
  end

  create_table "steps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "position", default: 0, null: false
    t.bigint "quest_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "xp_reward", default: 0, null: false
    t.index ["quest_id"], name: "index_steps_on_quest_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "earned_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "user_quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "position", default: 0, null: false
    t.bigint "quest_id", null: false
    t.string "share_token"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["quest_id"], name: "index_user_quests_on_quest_id"
    t.index ["share_token"], name: "index_user_quests_on_share_token", unique: true
    t.index ["user_id"], name: "index_user_quests_on_user_id"
  end

  create_table "user_steps", force: :cascade do |t|
    t.boolean "completed", default: false, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "step_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["step_id"], name: "index_user_steps_on_step_id"
    t.index ["user_id"], name: "index_user_steps_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "jti"
    t.integer "level", default: 0, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.integer "xp", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "quest_prerequisites", "quests"
  add_foreign_key "quest_prerequisites", "quests", column: "prerequisite_id"
  add_foreign_key "steps", "quests"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_quests", "quests"
  add_foreign_key "user_quests", "users"
  add_foreign_key "user_steps", "steps"
  add_foreign_key "user_steps", "users"
end
