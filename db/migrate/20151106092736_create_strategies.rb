class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.string :user_id
      t.string :category
      t.string :content
      t.integer :comment_count, default: 0
      t.timestamps null: false
    end
  end
end
