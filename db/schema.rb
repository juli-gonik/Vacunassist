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

ActiveRecord::Schema.define(version: 2021_12_07_140727) do

  create_table "appointments", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "dose", default: 0
    t.datetime "date"
    t.integer "vaccine"
    t.integer "user_patient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tipo"
    t.boolean "fiebre_amarilla"
    t.index ["user_patient_id"], name: "index_appointments_on_user_patient_id"
  end

  create_table "certificates", force: :cascade do |t|
    t.string "observations"
    t.integer "vaccine"
    t.integer "dose"
    t.integer "appointment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["appointment_id"], name: "index_certificates_on_appointment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "last_name"
    t.integer "dni"
    t.string "access_key"
    t.datetime "birth_date"
    t.boolean "risk_patient"
    t.integer "vacunatorio_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "fiebre_amarilla"
    t.string "type"
    t.boolean "first_sign_in", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["dni"], name: "index_users_on_dni", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["vacunatorio_id"], name: "index_users_on_vacunatorio_id"
  end

  create_table "vacunatorios", force: :cascade do |t|
    t.integer "zone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "place"
  end

  add_foreign_key "users", "vacunatorios"
end
