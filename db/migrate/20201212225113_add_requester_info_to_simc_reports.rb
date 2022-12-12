class AddRequesterInfoToSimcReports < ActiveRecord::Migration[6.0]
  def change
    add_column :simc_reports, :requester_id, :bigint
    add_column :simc_reports, :requester_message_id, :bigint
  end
end
