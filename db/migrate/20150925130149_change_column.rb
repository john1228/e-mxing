class ChangeColumn < ActiveRecord::Migration
  def change
    add_index :profiles, :name
    add_index :profiles, :address

    add_index :dynamic_comments, :dynamic_id
    add_index :skus, :seller_id
    add_index :profiles, :user_id
    add_index :service_members, :service_id
    add_index :service_members, :coach_id
    add_index :likes, [:liked_id, :like_type]

    add_column :users, :views, :integer, default: 14000
  end
end
