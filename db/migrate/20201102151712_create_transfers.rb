class CreateTransfers < ActiveRecord::Migration[6.0]
  def change
    create_table :transfers do |t|
      t.float :amount
      t.integer :amount_cents
      t.float :fees
      t.string :stripe_transfer
      t.references :organization, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
