class CreateHActivities < ActiveRecord::Migration
  def change
    create_table :h_activities do |t|
      t.references :user
      t.string :title
      t.string :cover
      t.datetime :start
      t.datetime :end
      t.datetime :enroll
      t.string :address
      t.string :gather
      t.integer :limit
      t.integer :integer
      t.text :stay
      t.text :insurance
      t.text :tip
      t.text :bak
      t.integer :apply_count
      t.integer :view_count
      t.timestamps null: false
    end
  end
end
