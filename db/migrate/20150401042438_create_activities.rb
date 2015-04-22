class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.string :cover
      t.string :address
      t.string :time
      t.string :url
      t.integer :group_id
      t.text :content

      t.timestamps null: false
    end
  end
end
