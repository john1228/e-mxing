class CreateDynamicComments < ActiveRecord::Migration
  def change
    create_table :dynamic_comments do |t|
      t.integer :dynamic_id
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end
end
