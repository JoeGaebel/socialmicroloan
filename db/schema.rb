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

ActiveRecord::Schema.define(version: 20170223022123) do

  create_table "campaign_supports", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "campaign_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "support_amount"
    t.boolean  "require_interest"
    t.index ["campaign_id", "user_id"], name: "index_campaign_supports_on_campaign_id_and_user_id", unique: true, using: :btree
    t.index ["campaign_id"], name: "index_campaign_supports_on_campaign_id", using: :btree
    t.index ["user_id"], name: "index_campaign_supports_on_user_id", using: :btree
  end

  create_table "campaigns", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "description",      limit: 65535
    t.date     "goal_date"
    t.integer  "repayment_length"
    t.integer  "interest_percent"
    t.integer  "goal_amount"
    t.integer  "pledged_amount"
    t.string   "picture"
    t.integer  "creator_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["creator_id"], name: "index_campaigns_on_creator_id", using: :btree
  end

  create_table "microposts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",    limit: 65535
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at", using: :btree
    t.index ["user_id"], name: "index_microposts_on_user_id", using: :btree
  end

  create_table "relationships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
    t.index ["follower_id"], name: "index_relationships_on_follower_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",                 default: false
    t.string   "activation_digest"
    t.boolean  "activated",             default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "publishable_key"
    t.string   "secret_key"
    t.string   "stripe_user_id"
    t.string   "currency"
    t.json     "stripe_account_status"
    t.string   "stripe_account_type"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "microposts", "users"
end
