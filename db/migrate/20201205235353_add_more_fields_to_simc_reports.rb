class AddMoreFieldsToSimcReports < ActiveRecord::Migration[6.0]
  def change
    add_column :simc_reports, :message_id, :bigint
    add_column :simc_reports, :text_report, :text, limit: 16.megabytes - 1
  end
end
