class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :coach
      t.string :name
      t.string :avatar
      t.string :mobile
      t.timestamps null: false
    end
  end
end
