class CreateMassMessageGroups < ActiveRecord::Migration
  def change
    create_table :mass_message_groups do |t|
      t.integer :service_id
      t.string :name
      t.integer :user_id, array: true, default: []
      t.timestamps null: false
    end
  end
end
