class AddRequestAttachementUrlToSimcReports < ActiveRecord::Migration[6.0]
  def change
    add_column :simc_reports, :requester_attachment_url, :string
  end
end
