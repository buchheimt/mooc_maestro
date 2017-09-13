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

ActiveRecord::Schema.define(version: 20170913163352) do

  create_table "course_subjects", force: :cascade do |t|
    t.integer "course_id"
    t.integer "subject_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "length_in_hours"
    t.integer "program_id"
    t.integer "creator_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "creator_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "certification"
    t.float "cost"
    t.string "affiliation"
    t.integer "platform_id"
    t.integer "creator_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "creator_id"
  end

  create_table "user_courses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float "progress_in_hours"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
  end

end
