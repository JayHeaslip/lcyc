class LogInfoEmail < ActiveRecord::Migration[7.0]
  def change
    create_table :log_info_email do |t|
      t.string :subject
      t.text :body
    end
  end
end
