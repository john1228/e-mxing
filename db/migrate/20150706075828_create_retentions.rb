class CreateRetentions < ActiveRecord::Migration
  def change
    create_table :retentions do |t|
      t.date :report_date
      t.integer :register
      t.decimal :day_one
      t.decimal :day_three
      t.decimal :day_seven
    end
  end
end
