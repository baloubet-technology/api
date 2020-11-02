class CreateVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :variants do |t|
      t.string :sku
      t.integer :quantity
      t.float :price
      t.integer :price_cents
      t.string :size
      t.string :color
      t.string :picture_url
      t.string :status, default: "Pending"
      t.references :product, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
