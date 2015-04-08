class CreateServiceMembers < ActiveRecord::Migration
  def change
    create_table :service_members do |t|
      t.integer :service_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
