class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :interests
      t.text :intro
      t.string :easemob_id
      t.integer :owner #群主

      t.timestamps null: false
    end
  end
end
