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

ActiveRecord::Schema.define(:version => 20120606142438) do

  create_table "announcements", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.boolean "status"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contacteds", :force => true do |t|
    t.string   "patient_first"
    t.string   "patient_last"
    t.date     "accident_date"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data"
  end

  create_table "e_files", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.integer  "size"
    t.integer  "user_id"
    t.integer  "db_file_id"
    t.integer  "status",            :default => 0
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "page_count"
    t.integer  "status_code"
    t.string   "status_condition"
    t.text     "error_description"
    t.date     "sent_date"
    t.date     "returned_date"
    t.string   "grantee_first"
    t.string   "grantee_last"
  end

  create_table "insurance_companies", :force => true do |t|
    t.string  "name"
    t.string  "address"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.integer "created_by"
  end

  create_table "liens", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "patient_last"
    t.string   "patient_first"
    t.string   "patient_address"
    t.string   "patient_city"
    t.string   "patient_state"
    t.string   "patient_zip"
    t.string   "patient_home"
    t.string   "patient_cell"
    t.string   "patient_attorney_name"
    t.string   "patient_attorney_address"
    t.string   "patient_attorney_city"
    t.string   "patient_attorney_state"
    t.string   "patient_attorney_zip"
    t.string   "patient_attorney_phone"
    t.string   "patient_attorney_fax"
    t.string   "patient_insurance_company"
    t.string   "patient_insurance_address"
    t.string   "patient_insurance_city"
    t.string   "patient_insurance_state"
    t.string   "patient_insurance_zip"
    t.string   "patient_insurance_adjuster"
    t.string   "patient_insurance_phone"
    t.string   "patient_insurance_ext"
    t.string   "patient_insurance_claim"
    t.string   "defendant_name"
    t.string   "defendant_address"
    t.string   "defendant_city"
    t.string   "defendant_state"
    t.string   "defendant_zip"
    t.string   "defendant_home"
    t.string   "defendant_cell"
    t.string   "defendant_insurance_company"
    t.string   "defendant_insurance_address"
    t.string   "defendant_insurance_city"
    t.string   "defendant_insurance_state"
    t.string   "defendant_insurance_zip"
    t.string   "defendant_insurance_adjuster"
    t.string   "defendant_insurance_phone"
    t.string   "defendant_insurance_ext"
    t.string   "defendant_insurance_claim"
    t.string   "other_name"
    t.string   "other_address"
    t.string   "other_city"
    t.string   "other_state"
    t.string   "other_zip"
    t.string   "other_home"
    t.string   "other_cell"
    t.string   "other_insurance_company"
    t.string   "other_insurance_address"
    t.string   "other_insurance_city"
    t.string   "other_insurance_state"
    t.string   "other_insurance_zip"
    t.string   "other_insurance_adjuster"
    t.string   "other_insurance_phone"
    t.string   "other_insurance_ext"
    t.string   "other_insurance_claim"
    t.date     "case_accident_date"
    t.date     "case_filed_date"
    t.date     "case_release_date"
    t.string   "case_book"
    t.string   "case_lien_number"
    t.float    "case_lien_amount"
    t.date     "case_collected_date"
    t.string   "case_page"
    t.date     "case_amend_date"
    t.text     "case_amend_reason"
    t.integer  "user_id"
    t.boolean  "case_status_not_final",        :default => false
    t.boolean  "case_status_amended",          :default => false
    t.boolean  "case_status_final",            :default => false
    t.boolean  "letter_sent",                  :default => false
  end

  create_table "newadmins", :force => true do |t|
    t.string  "name"
    t.string  "password"
    t.string  "crypted_password"
    t.string  "password_salt"
    t.string  "persistence_token"
    t.boolean "user_type"
  end

  create_table "notes", :force => true do |t|
    t.text     "body"
    t.integer  "lien_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "promocodes", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "valid"
    t.boolean  "used"
    t.integer  "user_id"
  end

  create_table "providers", :force => true do |t|
    t.string   "company"
    t.string   "category"
    t.string   "contact_name"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.text     "description"
    t.date     "start_date"
    t.integer  "contract_length"
    t.string   "rate"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "category_id"
  end

  create_table "referrals", :force => true do |t|
    t.integer  "provider_id"
    t.integer  "referrer_id"
    t.string   "patient_last"
    t.string   "patient_first"
    t.string   "patient_address"
    t.string   "patient_city"
    t.string   "patient_state"
    t.string   "patient_zip"
    t.string   "patient_home"
    t.string   "patient_cell"
    t.string   "patient_attorney_name"
    t.string   "patient_attorney_address"
    t.string   "patient_attorney_city"
    t.string   "patient_attorney_state"
    t.string   "patient_attorney_zip"
    t.string   "patient_attorney_phone"
    t.string   "patient_attorney_fax"
    t.string   "patient_insurance_company"
    t.string   "patient_insurance_address"
    t.string   "patient_insurance_city"
    t.string   "patient_insurance_state"
    t.string   "patient_insurance_zip"
    t.string   "patient_insurance_adjuster"
    t.string   "patient_insurance_phone"
    t.string   "patient_insurance_ext"
    t.string   "patient_insurance_claim"
    t.string   "defendant_name"
    t.string   "defendant_address"
    t.string   "defendant_city"
    t.string   "defendant_state"
    t.string   "defendant_zip"
    t.string   "defendant_home"
    t.string   "defendant_cell"
    t.string   "defendant_insurance_company"
    t.string   "defendant_insurance_address"
    t.string   "defendant_insurance_city"
    t.string   "defendant_insurance_state"
    t.string   "defendant_insurance_zip"
    t.string   "defendant_insurance_adjuster"
    t.string   "defendant_insurance_phone"
    t.string   "defendant_insurance_ext"
    t.string   "defendant_insurance_claim"
    t.string   "other_name"
    t.string   "other_address"
    t.string   "other_city"
    t.string   "other_state"
    t.string   "other_zip"
    t.string   "other_home"
    t.string   "other_cell"
    t.string   "other_insurance_company"
    t.string   "other_insurance_address"
    t.string   "other_insurance_city"
    t.string   "other_insurance_state"
    t.string   "other_insurance_zip"
    t.string   "other_insurance_adjuster"
    t.string   "other_insurance_phone"
    t.string   "other_insurance_ext"
    t.string   "other_insurance_claim"
    t.date     "case_accident_date"
    t.boolean  "added",                        :default => false
    t.boolean  "deleted",                      :default => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "email"
    t.string   "patient_insurance_name"
    t.string   "defendant_insurance_name"
    t.string   "other_insurance_name"
  end

  create_table "roles", :force => true do |t|
    t.string "rolename"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "password"
    t.string   "physician_name"
    t.string   "email"
    t.string   "clinic"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone_area"
    t.string   "phone_prefix"
    t.string   "phone_suffix"
    t.string   "tax"
    t.string   "payable"
    t.string   "county"
    t.integer  "paper"
    t.integer  "account"
    t.integer  "newsletter"
    t.string   "notary_name"
    t.string   "notary_county"
    t.string   "notary_commission"
    t.date     "notary_expires"
    t.boolean  "paid",                      :default => false
    t.datetime "subscribe_up_to"
    t.integer  "role_id",                   :default => 1
    t.integer  "provider_id"
    t.string   "reset_password_code"
    t.string   "reset_password_code_until"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
