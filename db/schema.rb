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

ActiveRecord::Schema.define(version: 2018_06_24_224250) do

  create_table "attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "mailing_id", null: false
    t.string "filename"
    t.integer "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "content_type"
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

  create_table "binnacles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.date "publication_date"
    t.text "body"
  end

  create_table "boats", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "location", limit: 12
    t.integer "mooring_num"
    t.index ["Mfg_Size"], name: "Mfg_Size"
    t.index ["id"], name: "id"
  end

  create_table "boats_memberships", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "boat_id"
    t.integer "membership_id"
    t.index ["boat_id", "membership_id"], name: "index_boats_memberships_on_boat_id_and_membership_id", unique: true
    t.index ["membership_id"], name: "index_boats_memberships_on_membership_id"
  end

  create_table "bounces", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "body"
    t.integer "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committee_name", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "Name"
  end

  create_table "committeemembers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "MemberId"
    t.string "Committee", limit: 50
    t.string "Role", limit: 50
    t.datetime "BeginTerm"
    t.datetime "EndTerm"
    t.string "Status", limit: 50
    t.index ["MemberId"], name: "MemberId"
  end

  create_table "committeeroles", primary_key: "Role", id: :string, limit: 50, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
  end

  create_table "committees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "Name"
  end

  create_table "currentseason", primary_key: "Year", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "queue"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "events", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "place"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "deadline"
  end

  create_table "mailings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "replyto"
    t.string "attachment"
    t.boolean "html"
    t.string "committee"
    t.datetime "sent_at"
  end

  create_table "memberships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "email_binnacle", default: false
    t.boolean "email_partner_binnacle", default: false
    t.string "alternate_email"
    t.date "application_date"
    t.date "active_date"
    t.date "change_status_date"
    t.integer "initiation"
    t.boolean "paid"
    t.boolean "skip_mooring"
    t.index ["Boat"], name: "Boat"
  end

  create_table "memberstatus", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "Status"
  end

  create_table "membertypes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "Type"
  end

  create_table "moorings", primary_key: "mooring_num", id: :integer, default: 0, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "Rating"
    t.string "Field", limit: 3
    t.string "Location", limit: 3
    t.integer "Depth"
    t.string "Type", limit: 50
    t.text "Notes", limit: 4294967295
    t.index ["mooring_num"], name: "mooring_num"
  end

  create_table "pdfs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "binnacle_id", null: false
    t.string "content_type"
    t.string "filename"
    t.integer "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "pdf_file_name"
    t.string "pdf_content_type"
    t.integer "pdf_file_size"
    t.datetime "pdf_updated_at"
  end

  create_table "people", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email_hash"
    t.boolean "subscribe_general", default: true
    t.boolean "select_email", default: false
    t.index ["MembershipID"], name: "MembershipID"
    t.index ["MembershipID"], name: "id"
    t.index ["id"], name: "id1"
  end

  create_table "reservations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "firstname"
    t.string "lastname"
    t.string "email"
    t.integer "event_id"
  end

  create_table "rights", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "signups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.date "date"
    t.integer "leader_id"
    t.integer "need"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signups_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "signup_id"
    t.integer "user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "email"
    t.string "salt"
    t.string "hashed_password"
    t.boolean "email_confirmed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "firstname"
    t.string "lastname"
    t.string "reset_password_code"
    t.datetime "reset_password_code_until"
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.string "confirmation_hash"
    t.integer "person_id"
  end

  create_table "wait_list_entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.date "date"
    t.string "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "membership_id"
  end

  add_foreign_key "memberships", "boats", column: "Boat", name: "memberships_ibfk_1", on_delete: :nullify
end
