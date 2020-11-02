class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :country
      t.string :country_code
      t.string :city
      t.string :line1
      t.string :postal_code
      t.string :state
      t.string :email
      t.string :phone
      t.string :tax_id
      t.string :vat_id
      t.string :recipient
      t.string :business_name
      t.string :business_description
      t.string :currency
      t.string :organization_url
      t.boolean :status, default: false
      t.float :fees
      t.uuid :certificate_of_incorporation_id
      t.uuid :bank_statement_id
      t.references :mcc, foreign_key: true
      t.references :rate, foreign_key: true

      t.timestamps
    end
  end
end
