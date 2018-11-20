class DrysailNum < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :drysail_num, :integer, default: nil, null: true
  end
end
