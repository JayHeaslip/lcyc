class AddRoleHierarchy < ActiveRecord::Migration[7.0]
  def change
    change_table :roles do |t|
      t.references :parent, type: :integer, foreign_key: { to_table: :roles }
    end
  end
end
