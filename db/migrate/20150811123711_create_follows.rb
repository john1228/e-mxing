class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :service
      t.references :user
      t.timestamps null: false
    end
  end
end
