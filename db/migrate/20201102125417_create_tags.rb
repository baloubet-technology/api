class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :rate_code
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
