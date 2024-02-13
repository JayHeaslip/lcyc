class PreferPartnerEmail < ActiveRecord::Migration[7.1]
  def change
    add_column :memberships, :prefer_partner_email, :boolean, default: false
  end
end
