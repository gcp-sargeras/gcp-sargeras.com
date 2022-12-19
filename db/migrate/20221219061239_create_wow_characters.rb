class CreateWowCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :wow_characters do |t|
      t.string :name, null: false, unique: true
      t.references :wow_server, null: false, foreign_key: true
      t.references :wow_region, null: false, foreign_key: true

      t.timestamps
    end
  end
end
