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

ActiveRecord::Schema.define(version: 20170223191440) do

  create_table "certificates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "cn",                                           null: false
    t.text     "last_crt",       limit: 65535
    t.text     "csr",            limit: 65535
    t.text     "key",            limit: 65535
    t.integer  "status",                       default: 0
    t.text     "status_detail",  limit: 65535
    t.boolean  "auto_renewal",                 default: false
    t.boolean  "revoked",                      default: false
    t.integer  "project_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "environment_id"
    t.datetime "expired_at"
    t.integer  "time_renewal",                 default: 30
    t.index ["cn"], name: "index_certificates_on_cn", unique: true, using: :btree
    t.index ["environment_id"], name: "index_certificates_on_environment_id", using: :btree
    t.index ["project_id"], name: "index_certificates_on_project_id", using: :btree
  end

  create_table "environments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "destination_crt"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                      null: false
    t.string   "email",                     null: false
    t.text     "private_pem", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["email"], name: "index_projects_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_projects_on_name", unique: true, using: :btree
  end

  create_table "projects_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id",    null: false
    t.integer "project_id", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role",                   default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "certificates", "environments"
  add_foreign_key "certificates", "projects", on_update: :cascade, on_delete: :cascade
end
