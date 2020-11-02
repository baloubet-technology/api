class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :line1
      t.string :city
      t.string :postal_code
      t.string :state
      t.string :country
      t.string :country_code
      t.float :amount
      t.integer :amount_cents
      t.string :charge
      t.string :payment_url

      t.timestamps
    end
  end
end
