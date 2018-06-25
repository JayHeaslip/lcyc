class AddSelectEmailtoPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :select_email, :boolean, default: false
  end
end
