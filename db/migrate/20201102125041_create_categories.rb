class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :hs_tariff_number

      t.timestamps
    end
  end
end
