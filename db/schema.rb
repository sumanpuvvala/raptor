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

ActiveRecord::Schema.define(version: 20161108091104) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classifications", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_links", id: false, force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "child_course_id"
    t.string   "link_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "id"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "title"
    t.text     "details"
    t.integer  "topic_id"
    t.string   "course_type"
    t.string   "time_estimate"
    t.string   "difficulty"
    t.string   "cost_course"
    t.string   "cost_certification"
    t.string   "member_id"
    t.decimal  "credits",            precision: 10, scale: 2
    t.string   "university"
    t.string   "url"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "topic_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "stream"
    t.string   "manager"
    t.boolean  "is_lead"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "named_lists", force: :cascade do |t|
    t.string   "list_name"
    t.string   "entry_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "member_id"
    t.string   "status"
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teammembers", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "member_id"
    t.string   "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_id"
    t.integer  "classification_id"
    t.integer  "team_id"
    t.text     "details"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "urls", force: :cascade do |t|
    t.string   "entity"
    t.string   "url"
    t.string   "url_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
