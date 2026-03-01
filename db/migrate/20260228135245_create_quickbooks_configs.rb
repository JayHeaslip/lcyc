class CreateQuickbooksConfigs < ActiveRecord::Migration[8.1]
  def change
    create_table :quickbooks_configs do |t|
      t.text :access_token
      t.text :refresh_token
      t.datetime :access_token_expires_at
      t.datetime :refresh_token_expires_at
      t.string :realm_id

      t.timestamps
    end
  end
end
