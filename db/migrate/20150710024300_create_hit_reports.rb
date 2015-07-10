class CreateHitReports < ActiveRecord::Migration
  def change
    create_table :hit_reports do |t|
      t.date :report_date
      t.integer :point
      t.integer :number
      t.timestamps null: false
    end
  end
end
