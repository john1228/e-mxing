class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :coach
      t.string :sku_id
      t.date :date
      t.string :start
      t.string :end
      t.integer :people_count
      t.text :remark

      t.integer :user_type
      t.integer :user_id
      t.string :user_name
      t.string :mobile
      t.timestamps null: false
    end
  end
end
