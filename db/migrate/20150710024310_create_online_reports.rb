class CreateOnlineReports < ActiveRecord::Migration
  def change
    create_table :online_reports do |t|
      t.date :report_date
      t.integer :avg
      t.integer :period
      t.integer :number
      t.timestamps null: false
    end
  end
end
