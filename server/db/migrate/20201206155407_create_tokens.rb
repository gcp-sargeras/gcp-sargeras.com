class CreateTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :tokens do |t|
      t.string :app
      t.string :token

      t.timestamps
    end
  end
end
