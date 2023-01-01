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

ActiveRecord::Schema[7.0].define(version: 2023_01_01_200150) do
  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.string "remember_token", null: false
    t.index ["remember_token"], name: "index_active_sessions_on_remember_token", unique: true
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "boats", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Mfg_Size", limit: 50
    t.string "Type", limit: 50
    t.string "Name", limit: 50
    t.integer "Length"
    t.string "Draft"
    t.string "Class", limit: 10
    t.integer "PHRF"
    t.string "sail_num", limit: 15
    t.string "Status", limit: 50
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "location", limit: 12
    t.integer "mooring_num"
    t.bigint "mooring_id"
    t.bigint "drysail_id"
    t.index ["Mfg_Size"], name: "Mfg_Size"
    t.index ["drysail_id"], name: "index_boats_on_drysail_id"
    t.index ["id"], name: "id"
    t.index ["mooring_id"], name: "index_boats_on_mooring_id"
  end

  create_table "boats_memberships", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "boat_id"
    t.integer "membership_id"
    t.index ["boat_id", "membership_id"], name: "index_boats_memberships_on_boat_id_and_membership_id", unique: true
    t.index ["membership_id"], name: "index_boats_memberships_on_membership_id"
  end

  create_table "bounces", id: :integer, charset: "latin1", force: :cascade do |t|
    t.text "body"
    t.integer "person_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "committee_name", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Name"
  end

  create_table "committeemembers", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "MemberId"
    t.string "Committee", limit: 50
    t.string "Role", limit: 50
    t.datetime "BeginTerm", precision: nil
    t.datetime "EndTerm", precision: nil
    t.string "Status", limit: 50
    t.index ["MemberId"], name: "MemberId"
  end

  create_table "committeeroles", primary_key: "Role", id: { type: :string, limit: 50 }, charset: "latin1", force: :cascade do |t|
  end

  create_table "committees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Name"
  end

  create_table "delayed_jobs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "queue"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "drysails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "membership_id"
    t.index ["membership_id"], name: "index_drysails_on_membership_id"
  end

  create_table "initiation_installments", charset: "utf8mb3", force: :cascade do |t|
    t.integer "amount"
    t.integer "year"
    t.integer "membership_id"
    t.index ["membership_id"], name: "fk_rails_2b86ebd36d"
  end

  create_table "mailings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "replyto"
    t.string "attachment"
    t.boolean "html"
    t.string "committee"
    t.datetime "sent_at", precision: nil
  end

  create_table "memberships", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "MailingName", limit: 100
    t.string "LastName", limit: 30
    t.string "StreetAddress", limit: 50
    t.string "City", limit: 30
    t.string "State", limit: 2
    t.string "Zip", limit: 12
    t.string "Country", limit: 15
    t.integer "mooring_num"
    t.string "MooringPaid", limit: 1
    t.string "DuesPaid", limit: 1
    t.string "MooringClubDiver", limit: 1
    t.integer "Boat"
    t.string "RacingRelease", limit: 1
    t.integer "MemberSince"
    t.string "Status", limit: 50
    t.string "LATE", limit: 50
    t.string "Miscellaneous", limit: 150
    t.integer "PartnerBoat1"
    t.integer "PartnerBoat2"
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "email_binnacle", default: false
    t.boolean "email_partner_binnacle", default: false
    t.string "alternate_email"
    t.date "application_date"
    t.date "active_date"
    t.date "change_status_date"
    t.integer "initiation"
    t.boolean "paid"
    t.boolean "skip_mooring"
    t.integer "installments"
    t.integer "initiation_fee"
    t.integer "drysail_num"
    t.text "notes"
    t.date "resignation_date"
    t.bigint "mooring_id"
    t.index ["Boat"], name: "Boat"
    t.index ["mooring_id"], name: "index_memberships_on_mooring_id"
  end

  create_table "memberstatus", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Status"
  end

  create_table "membertypes", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "Type"
  end

  create_table "moorings", id: :integer, default: 0, charset: "latin1", force: :cascade do |t|
    t.integer "Rating"
    t.string "Field", limit: 3
    t.string "Location", limit: 3
    t.integer "Depth"
    t.string "Type", limit: 50
    t.text "Notes", size: :long
    t.index ["id"], name: "mooring_num"
  end

  create_table "people", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "MembershipID", null: false
    t.string "MemberType", limit: 10
    t.string "LastName", limit: 20
    t.string "FirstName", limit: 20
    t.integer "BirthYear"
    t.string "Married", limit: 1
    t.string "HomePhone", limit: 25
    t.string "WorkPhone", limit: 25
    t.string "CellPhone", limit: 25
    t.string "OtherPhone1", limit: 25
    t.string "OtherPhone2", limit: 25
    t.string "Fax", limit: 25
    t.string "EmailAddress", limit: 50
    t.string "US_SAILING", limit: 1
    t.string "BOAT_US", limit: 1
    t.string "PLUMBING", limit: 1
    t.string "ELECTRICAL", limit: 1
    t.string "CARPENTRY", limit: 1
    t.string "HORTICULTURAL", limit: 1
    t.string "FINANCIAL", limit: 1
    t.string "ENGINE", limit: 1
    t.string "WELDING", limit: 1
    t.string "PAINTING", limit: 1
    t.string "COMPUTING", limit: 1
    t.string "OTHER", limit: 100
    t.string "Committee1", limit: 50
    t.string "Committee2", limit: 50
    t.string "Committee3", limit: 50
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "email_hash"
    t.boolean "subscribe_general", default: true
    t.boolean "select_email", default: false
    t.bigint "committee_id"
    t.index ["MembershipID"], name: "MembershipID"
    t.index ["MembershipID"], name: "id"
    t.index ["committee_id"], name: "index_people_on_committee_id"
    t.index ["id"], name: "id1"
  end

  create_table "rights", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_roles_on_parent_id"
  end

  create_table "users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "firstname"
    t.string "lastname"
    t.integer "person_id"
    t.string "password_digest"
    t.datetime "confirmed_at"
    t.bigint "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "wait_list_entries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.date "date"
    t.text "notes"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "membership_id"
  end

  add_foreign_key "active_sessions", "users", on_delete: :cascade
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "initiation_installments", "memberships"
  add_foreign_key "memberships", "boats", column: "Boat", name: "memberships_ibfk_1", on_delete: :nullify
end
