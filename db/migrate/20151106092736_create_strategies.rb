class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.string :user_id
      t.string :category
      t.string :content
      t.timestamps null: false
    end
  end
end
