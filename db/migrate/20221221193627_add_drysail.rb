class AddDrysail < ActiveRecord::Migration[7.0]
  def change
    create_table :drysails do |t|
      t.belongs_to :membership
    end

    change_table :boats do |t|
      t.belongs_to :drysail
    end
  end
end
