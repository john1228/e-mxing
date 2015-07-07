class CreateOverviews < ActiveRecord::Migration
  def change
    create_table :overviews do |t|
      t.date :report_date
      t.integer :activation
      t.integer :register
      t.integer :activity
    end
  end
end
