class AllowNullMooringOnMembership < ActiveRecord::Migration[7.0]
  def change
    change_column_null :memberships, :mooring_id, true 
  end
end
