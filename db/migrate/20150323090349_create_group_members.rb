class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.integer :group_id
      t.integer :user_id
      t.integer :tag, default: 1
      t.string :tag_name, string: '普通成员'

      t.timestamps null: false
    end
  end
end
