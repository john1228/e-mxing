class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :like_type
      t.integer :user_id
      t.integer :liked_id

      t.timestamps null: false
    end
  end
end
