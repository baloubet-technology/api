class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.float :price
      t.integer :price_cents
      t.float :shipping_price
      t.integer :shipping_price_cents
      t.float :rate_product
      t.float :rate_organization
      t.float :fees
      t.string :status
      t.string :tracking_url
      t.string :tracking_code
      t.string :tracker_id
      t.string :shipping_label
      t.string :order_url
      t.boolean :order_status, default: false
      t.boolean :transfer_status, default: false
      t.boolean :refund_status, default: false
      t.references :organization, foreign_key: true
      t.references :variant, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
