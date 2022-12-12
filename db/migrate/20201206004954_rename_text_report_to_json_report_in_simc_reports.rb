class RenameTextReportToJsonReportInSimcReports < ActiveRecord::Migration[6.0]
  def change
    remove_column :simc_reports, :text_report
    add_column :simc_reports, :json_report, :jsonb, null: false, default: '{}'
  end
end
