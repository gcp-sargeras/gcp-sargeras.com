class CreateWowRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :wow_regions do |t|
      t.string :name, null: false, unique: true
      t.timestamps
    end
  end
end
