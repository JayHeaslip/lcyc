class AddActiveSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :active_sessions do |t|
      t.integer :user_id, null: false
      t.timestamps
      t.string :user_agent
      t.string :ip_address
      t.string :remember_token, null: false
      t.index :remember_token, unique: true
      t.index :user_id
    end

    remove_column :users, :email_confirmed
    remove_column :users, :reset_password_code
    remove_column :users, :reset_password_code_until
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    remove_column :users, :confirmation_hash
    add_index :users, :email, unique: true
    add_foreign_key :active_sessions, :users, on_delete: :cascade

    drop_table :sessions
  end
end
