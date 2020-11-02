class CreateConnects < ActiveRecord::Migration[6.0]
  def change
    create_table :connects do |t|
      t.string :key
      t.references :organization, foreign_key: true
      t.references :software, foreign_key: true

      t.timestamps
    end
  end
end
