class AddCommitteeAssociation < ActiveRecord::Migration[7.0]
  def change
    change_table :people do |t|
      t.belongs_to :committee
    end
  end
end
