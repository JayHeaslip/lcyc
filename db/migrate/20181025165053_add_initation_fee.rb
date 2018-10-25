class AddInitationFee < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :installments, :integer, default: nil, null: true
    add_column :memberships, :initiation_fee, :integer, default: nil, null: true
  end
end
