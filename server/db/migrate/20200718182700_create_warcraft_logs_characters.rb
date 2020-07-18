class CreateWarcraftLogsCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :warcraft_logs_characters do |t|
      t.string :name
      t.string :klass
      t.string :sub_klass
      t.string :server

      t.timestamps
    end
  end
end
