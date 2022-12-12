class CreateWarcraftLogsFights < ActiveRecord::Migration[6.0]
  def change
    create_table :warcraft_logs_fights do |t|
      t.references :warcraft_logs_reports, index: true

      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :boss
      t.string :name
      t.integer :size
      t.integer :difficulty
      t.boolean :kill
      t.integer :partial
      t.integer :bossPercentage
      t.integer :fightPercentage
      t.integer :lastPhaseForPercentageDisplay

      t.timestamps default: DateTime.now
    end
  end
end
