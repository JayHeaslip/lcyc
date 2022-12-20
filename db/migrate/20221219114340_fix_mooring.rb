class FixMooring < ActiveRecord::Migration[7.0]
  def change

    change_table :moorings do |t|
      t.rename :mooring_num, :id
    end
    
    change_table :memberships do |t|
      t.belongs_to :mooring, index: true, null: true
    end
    
    add_foreign_key :memberships, :moorings

    drop_join_table :memberships, :moorings
  end
end
