class AddRequesterChannelToSimcReports < ActiveRecord::Migration[6.0]
  def change
    add_column :simc_reports, :requester_channel_id, :bigint
  end
end
