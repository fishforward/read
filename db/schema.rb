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

ActiveRecord::Schema.define(:version => 20131121141155) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.string   "pic_url"
    t.string   "last_pub_date"
    t.string   "default_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "authors", ["id"], :name => "index_authors_on_id"
  add_index "authors", ["name"], :name => "index_authors_on_name", :unique => true

  create_table "historysources", :force => true do |t|
    t.integer  "site_id"
    t.string   "site_name"
    t.integer  "author_id"
    t.string   "author_name"
    t.string   "post_date"
    t.string   "title"
    t.text     "content"
    t.text     "text_content"
    t.text     "pic_url"
    t.text     "post_url"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "historysources", ["created_at"], :name => "index_historysources_on_created_at"
  add_index "historysources", ["id"], :name => "index_historysources_on_id"
  add_index "historysources", ["status"], :name => "index_historysources_on_status"

  create_table "pics", :force => true do |t|
    t.integer  "post_id"
    t.integer  "order"
    t.string   "old_link"
    t.string   "link"
    t.string   "keypic"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => false do |t|
    t.integer  "site_id"
    t.string   "site_name"
    t.integer  "author_id"
    t.string   "author_name"
    t.string   "post_date"
    t.string   "title"
    t.text     "content"
    t.text     "text_content"
    t.text     "pic_url"
    t.text     "post_url"
    t.string   "status"
    t.integer  "yes"
    t.integer  "no"
    t.integer  "pv"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "score"
  end

  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["id"], :name => "index_posts_on_id"
  add_index "posts", ["status"], :name => "index_posts_on_status"

  create_table "posts_users", :force => false do |t|
    t.integer "post_id", :null => false
    t.integer "user_id", :null => false
  end

  create_table "sites", :force => false do |t|
    t.string   "name"
    t.string   "status"
    t.string   "url"
    t.string   "auto_read"
    t.string   "read_url"
    t.string   "read_type"
    t.string   "last_pub_date"
    t.string   "name_tag"
    t.string   "content_tag"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "author"
    t.string   "pv_tag"
    t.string   "comment_tag"
    t.string   "transmit_tag"
    t.string   "love_tag"
    t.string   "replace_tag"
  end

  create_table "sources", :force => true do |t|
    t.integer  "site_id"
    t.string   "site_name"
    t.integer  "author_id"
    t.string   "author_name"
    t.string   "post_date"
    t.string   "title"
    t.text     "content"
    t.text     "text_content"
    t.text     "pic_url"
    t.text     "post_url"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "pv"
    t.integer  "comment"
    t.integer  "transmit"
    t.integer  "love"
    t.integer  "adjust"
    t.integer  "score"
  end

  add_index "sources", ["created_at"], :name => "index_sources_on_created_at"
  add_index "sources", ["id"], :name => "index_sources_on_id"
  add_index "sources", ["status"], :name => "index_sources_on_status"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => false do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
