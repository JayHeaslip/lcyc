class Cleanup < ActiveRecord::Migration[7.0]
  def change
    change_column :wait_list_entries, :notes, :text
    drop_table :attachments
    drop_table :binnacles
    drop_table :currentseason
    drop_table :events
    drop_table :pdfs
    drop_table :reservations
    drop_table :signups
    drop_join_table :signups, :users
  end
end
