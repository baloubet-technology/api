class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.float :length
      t.float :width
      t.float :height
      t.float :weight
      t.float :price
      t.integer :price_cents

      t.timestamps
    end
  end
end
