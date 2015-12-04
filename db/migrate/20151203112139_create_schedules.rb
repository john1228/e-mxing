class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :coach
      t.references :user
      t.references :sku
      t.date :date
      t.string :start
      t.string :end
      t.string :user_name
      t.string :mobile
      t.integer :people_count
      t.timestamps null: false
    end
  end
end
