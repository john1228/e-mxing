class CreateActivityComments < ActiveRecord::Migration
  def change
    create_table :activity_comments do |t|
      t.integer :user_id
      t.integer :h_activity_id
      t.string :content
      t.string :image, array: true, default: []
      t.timestamps null: false
    end
  end
end
