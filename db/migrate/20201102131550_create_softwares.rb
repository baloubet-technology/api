class CreateSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :softwares do |t|
      t.string :name

      t.timestamps
    end
  end
end
