class ResignedDate < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :resignation_date, :date
  end
end
