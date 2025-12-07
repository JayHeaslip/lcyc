class AddFeesTable < ActiveRecord::Migration[8.1]
  def change
    create_table :fees do |t|
      t.integer :active
      t.integer :senior
      t.integer :inactive
      t.integer :associate
      t.integer :mooring_fee
      t.integer :mooring_replacement_fee
      t.integer :drysail_fee
      t.boolean :skip_docks_assessment
    end
  end
end
