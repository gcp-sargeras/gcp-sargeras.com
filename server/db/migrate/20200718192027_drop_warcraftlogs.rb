class DropWarcraftlogs < ActiveRecord::Migration[6.0]
  def change
    drop_table :warcraftlogs
  end
end
