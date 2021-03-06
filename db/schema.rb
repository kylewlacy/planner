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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "course_schedules", :force => true do |t|
    t.integer  "course_id"
    t.integer  "schedule_id"
    t.integer  "period"
    t.integer  "start_integer"
    t.integer  "end_integer"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "json_data"
    t.integer  "user_id"
    t.integer  "student_courses_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "schedules", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "schedule_courses_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "student_courses", :force => true do |t|
    t.text    "json_data"
    t.integer "student_id"
    t.integer "course_id"
  end

  create_table "tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "value"
    t.string   "client_value"
    t.string   "type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_hash"
    t.boolean  "confirmed",     :default => false
    t.string   "type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

end
