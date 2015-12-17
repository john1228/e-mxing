class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :coach
      t.references :user
      t.string :sku_id
      t.date :date
      t.string :start
      t.string :end
      t.string :mobile
      t.integer :people_count
      t.text :remark
      t.timestamps null: false
    end
  end
end
