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

ActiveRecord::Schema.define(version: 20180327164646) do

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "user_id",                     null: false
    t.string   "user_type"
    t.string   "document_id"
    t.string   "document_type"
    t.binary   "title",         limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["document_id"], name: "index_bookmarks_on_document_id", using: :btree
    t.index ["document_type", "document_id"], name: "index_bookmarks_on_document_type_and_document_id", using: :btree
    t.index ["user_id"], name: "index_bookmarks_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }, using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.binary   "query_params", limit: 65535
    t.integer  "user_id"
    t.string   "user_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_searches_on_user_id", using: :btree
  end

  create_table "spotlight_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "file"
    t.string   "uid"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_blacklight_configurations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "exhibit_id"
    t.text     "facet_fields",              limit: 65535
    t.text     "index_fields",              limit: 65535
    t.text     "search_fields",             limit: 65535
    t.text     "sort_fields",               limit: 65535
    t.text     "default_solr_params",       limit: 65535
    t.text     "show",                      limit: 65535
    t.text     "index",                     limit: 65535
    t.integer  "default_per_page"
    t.text     "per_page",                  limit: 65535
    t.text     "document_index_view_types", limit: 65535
    t.string   "thumbnail_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_contact_emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "exhibit_id"
    t.string   "email",                default: "", null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["confirmation_token"], name: "index_spotlight_contact_emails_on_confirmation_token", unique: true, using: :btree
    t.index ["email", "exhibit_id"], name: "index_spotlight_contact_emails_on_email_and_exhibit_id", unique: true, using: :btree
  end

  create_table "spotlight_contacts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "slug"
    t.string   "name"
    t.string   "email"
    t.string   "title"
    t.string   "location"
    t.string   "telephone"
    t.boolean  "show_in_sidebar"
    t.integer  "weight",                        default: 50
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "contact_info",    limit: 65535
    t.string   "avatar"
    t.integer  "avatar_crop_x"
    t.integer  "avatar_crop_y"
    t.integer  "avatar_crop_w"
    t.integer  "avatar_crop_h"
    t.integer  "avatar_id"
    t.index ["avatar_id"], name: "index_spotlight_contacts_on_avatar_id", using: :btree
    t.index ["exhibit_id"], name: "index_spotlight_contacts_on_exhibit_id", using: :btree
  end

  create_table "spotlight_custom_fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "exhibit_id"
    t.string   "slug"
    t.string   "field"
    t.text     "configuration",  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "field_type"
    t.boolean  "readonly_field",               default: false
  end

  create_table "spotlight_exhibits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title",                                        null: false
    t.string   "subtitle"
    t.string   "slug"
    t.text     "description",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout"
    t.boolean  "published",                    default: false
    t.datetime "published_at"
    t.string   "featured_image"
    t.integer  "masthead_id"
    t.integer  "thumbnail_id"
    t.integer  "weight",                       default: 50
    t.integer  "site_id"
    t.string   "theme"
    t.index ["site_id"], name: "index_spotlight_exhibits_on_site_id", using: :btree
    t.index ["slug"], name: "index_spotlight_exhibits_on_slug", unique: true, using: :btree
  end

  create_table "spotlight_featured_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "type"
    t.boolean  "display"
    t.string   "image"
    t.string   "source"
    t.string   "document_global_id"
    t.integer  "image_crop_x"
    t.integer  "image_crop_y"
    t.integer  "image_crop_w"
    t.integer  "image_crop_h"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "iiif_region"
    t.string   "iiif_manifest_url"
    t.string   "iiif_canvas_id"
    t.string   "iiif_image_id"
    t.string   "iiif_tilesource"
  end

  create_table "spotlight_filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "field"
    t.string   "value"
    t.integer  "exhibit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exhibit_id"], name: "index_spotlight_filters_on_exhibit_id", using: :btree
  end

  create_table "spotlight_locks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "on_id"
    t.string   "on_type"
    t.integer  "by_id"
    t.string   "by_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["on_id", "on_type"], name: "index_spotlight_locks_on_on_id_and_on_type", unique: true, using: :btree
  end

  create_table "spotlight_main_navigations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "label"
    t.integer  "weight",     default: 20
    t.string   "nav_type"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display",    default: true
    t.index ["exhibit_id"], name: "index_spotlight_main_navigations_on_exhibit_id", using: :btree
  end

  create_table "spotlight_pages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title"
    t.string   "type"
    t.string   "slug"
    t.string   "scope"
    t.text     "content",           limit: 16777215
    t.integer  "weight",                             default: 50
    t.boolean  "published"
    t.integer  "exhibit_id"
    t.integer  "created_by_id"
    t.integer  "last_edited_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_page_id"
    t.boolean  "display_sidebar"
    t.boolean  "display_title"
    t.integer  "thumbnail_id"
    t.boolean  "in_menu",                            default: true, null: false
    t.index ["exhibit_id"], name: "index_spotlight_pages_on_exhibit_id", using: :btree
    t.index ["parent_page_id"], name: "index_spotlight_pages_on_parent_page_id", using: :btree
    t.index ["slug", "scope"], name: "index_spotlight_pages_on_slug_and_scope", unique: true, using: :btree
  end

  create_table "spotlight_reindexing_log_entries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "items_reindexed_count"
    t.integer  "items_reindexed_estimate"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "job_status"
    t.integer  "exhibit_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spotlight_resources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "exhibit_id"
    t.string   "type"
    t.string   "url"
    t.text     "data",         limit: 65535
    t.datetime "indexed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "metadata",     limit: 65535
    t.integer  "index_status"
    t.integer  "upload_id"
    t.index ["index_status"], name: "index_spotlight_resources_on_index_status", using: :btree
    t.index ["upload_id"], name: "index_spotlight_resources_on_upload_id", using: :btree
  end

  create_table "spotlight_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.string  "role"
    t.integer "resource_id"
    t.string  "resource_type"
    t.index ["resource_type", "resource_id", "user_id"], name: "index_spotlight_roles_on_resource_and_user_id", unique: true, using: :btree
  end

  create_table "spotlight_searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "title"
    t.string   "slug"
    t.string   "scope"
    t.text     "short_description",       limit: 65535
    t.text     "long_description",        limit: 65535
    t.text     "query_params",            limit: 65535
    t.integer  "weight"
    t.boolean  "published"
    t.integer  "exhibit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "featured_item_id"
    t.integer  "masthead_id"
    t.integer  "thumbnail_id"
    t.string   "default_index_view_type"
    t.boolean  "search_box",                            default: false
    t.index ["exhibit_id"], name: "index_spotlight_searches_on_exhibit_id", using: :btree
    t.index ["slug", "scope"], name: "index_spotlight_searches_on_slug_and_scope", unique: true, using: :btree
  end

  create_table "spotlight_sites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "title"
    t.string  "subtitle"
    t.integer "masthead_id"
  end

  create_table "spotlight_solr_document_sidecars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "exhibit_id"
    t.boolean  "public",                         default: true
    t.text     "data",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_id"
    t.string   "document_type"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.binary   "index_status",  limit: 16777215
    t.index ["document_type", "document_id"], name: "spotlight_solr_document_sidecars_solr_document", using: :btree
    t.index ["exhibit_id", "document_type", "document_id"], name: "spotlight_solr_document_sidecars_exhibit_document", using: :btree
    t.index ["exhibit_id"], name: "index_spotlight_solr_document_sidecars_on_exhibit_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "spotlight_solr_document_sidecars_resource", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "tag_id"
    t.string   "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string  "name",                       collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "value",          limit: 65535
    t.text     "interpolations", limit: 65535
    t.boolean  "is_proc",                      default: false
    t.integer  "exhibit_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["exhibit_id"], name: "index_translations_on_exhibit_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "guest",                  default: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "username"
    t.string   "remember_token"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

end
