class InitiationInstallments < ActiveRecord::Migration[5.2]
  def change
    create_table :initiation_installments do |t|
      t.integer :amount
      t.date :year
      t.integer :membership_id
    end
    add_foreign_key :initiation_installments, :memberships
  end
end
