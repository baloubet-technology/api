class CreateRefunds < ActiveRecord::Migration[6.0]
  def change
    create_table :refunds do |t|
      t.float :refund_price
      t.integer :refund_price_cents
      t.float :shipping_price
      t.integer :shipping_price_cents
      t.string :tracking_url
      t.string :tracking_code
      t.string :tracker_id
      t.string :shipping_label
      t.string :stripe_refund
      t.string :status
      t.references :order, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
