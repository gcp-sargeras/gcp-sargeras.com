class AddCustomStringToSimcReports < ActiveRecord::Migration[6.0]
  def change
    add_column :simc_reports, :custom_string, :text, limit: 3000
  end
end
