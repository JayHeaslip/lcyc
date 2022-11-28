class UserUpdate < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :password_digest
      t.remove :salt
      t.remove :hashed_password
    end
  end
end
