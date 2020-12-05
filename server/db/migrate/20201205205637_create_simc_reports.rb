class CreateSimcReports < ActiveRecord::Migration[6.0]
  def change
    create_table :simc_reports do |t|
      t.string :character, null: false
      t.string :server, null: false, default: 'sargeras'
      t.string :region, null: false, default: 'us'
      t.text :options
      t.text :html_report, limit: 16.megabytes - 1

      t.timestamps
    end
  end
end
