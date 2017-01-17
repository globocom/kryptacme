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

ActiveRecord::Schema.define(version: 20161214011246) do

  create_table "certificates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "cn",                       null: false
    t.text     "last_crt",   limit: 65535
    t.text     "csr",        limit: 65535
    t.text     "key",        limit: 65535
    t.text     "detail",     limit: 65535
    t.string   "acme_id"
    t.integer  "owner_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["cn"], name: "index_certificates_on_cn", unique: true, using: :btree
    t.index ["owner_id"], name: "index_certificates_on_owner_id", using: :btree
  end

  create_table "owners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                      null: false
    t.string   "email",                     null: false
    t.text     "private_pem", limit: 65535
    t.text     "detail",      limit: 65535
    t.string   "acme_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["email"], name: "index_owners_on_email", unique: true, using: :btree
    t.index ["name"], name: "index_owners_on_name", unique: true, using: :btree
  end

  add_foreign_key "certificates", "owners", on_update: :cascade, on_delete: :cascade
end
