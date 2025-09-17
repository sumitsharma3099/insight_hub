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

ActiveRecord::Schema[8.0].define(version: 2025_09_17_155016) do
  create_table "articles", force: :cascade do |t|
    t.string "author"
    t.text "title"
    t.text "description"
    t.text "url"
    t.string "source"
    t.text "image"
    t.string "category"
    t.string "language"
    t.string "country"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "meta_title"
    t.text "meta_description"
    t.text "keywords"
    t.text "global_meta_title"
    t.text "global_meta_description"
    t.text "global_keywords"
  end

  create_table "seo_keywords", force: :cascade do |t|
    t.string "keyword"
    t.integer "count"
    t.string "category"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "seo_meta_data", force: :cascade do |t|
    t.text "page_title"
    t.text "meta_description"
    t.text "meta_keywords"
    t.text "og_title"
    t.text "og_description"
    t.text "twitter_title"
    t.text "twitter_description"
    t.text "structured_data"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trending_topics", force: :cascade do |t|
    t.string "topic"
    t.integer "count"
    t.string "category"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
