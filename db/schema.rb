# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_02_152213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "hs_tariff_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "connects", force: :cascade do |t|
    t.string "key"
    t.bigint "organization_id"
    t.bigint "software_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_connects_on_organization_id"
    t.index ["software_id"], name: "index_connects_on_software_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "file_id"
    t.boolean "is_verified", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mccs", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "members", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "birthday"
    t.string "city"
    t.string "line1"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.string "country_code"
    t.boolean "director"
    t.boolean "executive"
    t.boolean "owner"
    t.boolean "representative"
    t.string "percent_ownership"
    t.uuid "passport_id"
    t.uuid "proof_of_address_id"
    t.bigint "organization_id"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.text "authentication_token"
    t.datetime "authentication_token_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["authentication_token"], name: "index_members_on_authentication_token", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["organization_id"], name: "index_members_on_organization_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "orders", force: :cascade do |t|
    t.integer "quantity"
    t.float "price"
    t.integer "price_cents"
    t.float "shipping_price"
    t.integer "shipping_price_cents"
    t.float "rate_product"
    t.float "rate_organization"
    t.float "fees"
    t.string "status"
    t.string "tracking_url"
    t.string "tracking_code"
    t.string "tracker_id"
    t.string "shipping_label"
    t.string "order_url"
    t.boolean "order_status", default: false
    t.boolean "transfer_status", default: false
    t.boolean "refund_status", default: false
    t.bigint "organization_id"
    t.bigint "variant_id"
    t.bigint "payment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_orders_on_organization_id"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["variant_id"], name: "index_orders_on_variant_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.string "country_code"
    t.string "city"
    t.string "line1"
    t.string "postal_code"
    t.string "state"
    t.string "email"
    t.string "phone"
    t.string "tax_id"
    t.string "vat_id"
    t.string "recipient"
    t.string "business_name"
    t.string "business_description"
    t.string "currency"
    t.string "organization_url"
    t.boolean "status", default: false
    t.float "fees"
    t.uuid "certificate_of_incorporation_id"
    t.uuid "bank_statement_id"
    t.bigint "mcc_id"
    t.bigint "rate_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mcc_id"], name: "index_organizations_on_mcc_id"
    t.index ["rate_id"], name: "index_organizations_on_rate_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.float "length"
    t.float "width"
    t.float "height"
    t.float "weight"
    t.float "price"
    t.integer "price_cents"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "line1"
    t.string "city"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.string "country_code"
    t.float "amount"
    t.integer "amount_cents"
    t.string "charge"
    t.string "payment_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "stripe_product"
    t.string "status", default: "Pending"
    t.bigint "tag_id"
    t.bigint "brand_id"
    t.bigint "organization_id"
    t.bigint "package_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["organization_id"], name: "index_products_on_organization_id"
    t.index ["package_id"], name: "index_products_on_package_id"
    t.index ["tag_id"], name: "index_products_on_tag_id"
  end

  create_table "rates", force: :cascade do |t|
    t.string "country_code"
    t.float "R000"
    t.float "R001"
    t.float "R002"
    t.float "R003"
    t.float "R004"
    t.float "R005"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "refunds", force: :cascade do |t|
    t.float "refund_price"
    t.integer "refund_price_cents"
    t.float "shipping_price"
    t.integer "shipping_price_cents"
    t.string "tracking_url"
    t.string "tracking_code"
    t.string "tracker_id"
    t.string "shipping_label"
    t.string "stripe_refund"
    t.string "status"
    t.bigint "order_id"
    t.bigint "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_refunds_on_order_id"
    t.index ["organization_id"], name: "index_refunds_on_organization_id"
  end

  create_table "softwares", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "rate_code"
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_tags_on_category_id"
  end

  create_table "transfers", force: :cascade do |t|
    t.float "amount"
    t.integer "amount_cents"
    t.float "fees"
    t.string "stripe_transfer"
    t.bigint "organization_id"
    t.bigint "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_transfers_on_order_id"
    t.index ["organization_id"], name: "index_transfers_on_organization_id"
  end

  create_table "variants", force: :cascade do |t|
    t.string "sku"
    t.integer "quantity"
    t.float "price"
    t.integer "price_cents"
    t.string "size"
    t.string "color"
    t.string "picture_url"
    t.string "status", default: "Pending"
    t.bigint "product_id"
    t.bigint "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_variants_on_organization_id"
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "connects", "organizations"
  add_foreign_key "connects", "softwares"
  add_foreign_key "members", "organizations"
  add_foreign_key "orders", "organizations"
  add_foreign_key "orders", "payments"
  add_foreign_key "orders", "variants"
  add_foreign_key "organizations", "mccs"
  add_foreign_key "organizations", "rates"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "organizations"
  add_foreign_key "products", "packages"
  add_foreign_key "products", "tags"
  add_foreign_key "refunds", "orders"
  add_foreign_key "refunds", "organizations"
  add_foreign_key "tags", "categories"
  add_foreign_key "transfers", "orders"
  add_foreign_key "transfers", "organizations"
  add_foreign_key "variants", "organizations"
  add_foreign_key "variants", "products"
end
