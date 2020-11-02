class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents do |t|
      t.string :file_id
      t.boolean :is_verified, default: false

      t.timestamps
    end
  end
end
