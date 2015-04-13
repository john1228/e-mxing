class CreateDynamics < ActiveRecord::Migration
  def change
    create_table :dynamics do |t|
      t.integer :user_id
      t.text :content
      t.integer :top

      t.timestamps
    end
  end
end
