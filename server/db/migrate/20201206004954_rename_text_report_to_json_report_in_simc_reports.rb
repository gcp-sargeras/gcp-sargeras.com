class RenameTextReportToJsonReportInSimcReports < ActiveRecord::Migration[6.0]
  def change
    rename_column :simc_reports, :text_report, :json_report
  end
end
