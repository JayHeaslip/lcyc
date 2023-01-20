class FixRoles < ActiveRecord::Migration[7.0]
  def change
    drop_join_table :roles, :users

    change_table :users do |t|
      t.belongs_to :role
    end
      
  end
end
