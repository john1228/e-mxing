class AddIndexs < ActiveRecord::Migration
  def change
    add_index :dynamic_comments, :dynamic_id
    add_index :profiles, :user_id
  end
end
