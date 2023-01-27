class NewJoinTables < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships_moorings, id: false do |t|
      t.belongs_to :membership
      t.belongs_to :mooring
    end

    change_table :boats do |t|
      t.belongs_to :mooring
    end
  end
end
