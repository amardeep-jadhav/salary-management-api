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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_175353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "city"
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "USD", null: false
    t.date "date_of_birth"
    t.uuid "department_id", null: false
    t.string "email", null: false
    t.string "employment_type", default: "full_time", null: false
    t.string "full_name", null: false
    t.string "gender"
    t.date "hired_on", null: false
    t.uuid "job_title_id", null: false
    t.string "phone"
    t.decimal "salary", precision: 12, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["active", "country"], name: "index_employees_on_active_and_country"
    t.index ["active"], name: "index_employees_on_active"
    t.index ["city"], name: "index_employees_on_city"
    t.index ["country", "job_title_id"], name: "index_employees_on_country_and_job_title_id"
    t.index ["country"], name: "index_employees_on_country"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["hired_on"], name: "index_employees_on_hired_on"
    t.index ["job_title_id"], name: "index_employees_on_job_title_id"
    t.index ["salary"], name: "index_employees_on_salary"
  end

  create_table "job_titles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "level", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_job_titles_on_level"
    t.index ["name"], name: "index_job_titles_on_name", unique: true
  end

  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "job_titles"
end
