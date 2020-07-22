class CreateWarcraftLogsReports < ActiveRecord::Migration[6.0]
  def change
    create_table(:warcraft_logs_reports, id: false) do |t|
      t.string :id, primary_key: true, index: true
      t.string :title
      t.string :owner, index: true
      t.date :start
      t.date :end
      t.string :zone

      t.timestamps
    end
  end
end
