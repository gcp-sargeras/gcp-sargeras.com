class CreateWarcraftlogs < ActiveRecord::Migration[6.0]
  def change
    create_table :warcraftlogs do |t|
      t.string :url
      t.references :user

      t.timestamps
    end
  end
end
