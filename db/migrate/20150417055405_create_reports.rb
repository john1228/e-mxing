class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :report_type
      t.text :content
      t.integer :user_id
      t.integer :report_id

      t.timestamps null: false
    end
  end
end
