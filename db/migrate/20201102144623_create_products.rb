class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :stripe_product
      t.string :status, default: "Pending"
      t.references :tag, foreign_key: true
      t.references :brand, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :package, foreign_key: true

      t.timestamps
    end
  end
end
