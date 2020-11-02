class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.string :country_code
      t.float :R000
      t.float :R001
      t.float :R002
      t.float :R003
      t.float :R004
      t.float :R005

      t.timestamps
    end
  end
end
