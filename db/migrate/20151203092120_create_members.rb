class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :client_id
      t.integer :service_id
      t.integer :coach_id
      t.integer :user_id
      t.string :name
      t.string :avatar
      t.date :birthday
      t.string :address
      t.string :source
      t.string :mobile
      t.string :remark
      t.timestamps null: false
    end
  end
end
