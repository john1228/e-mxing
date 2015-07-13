class CreateBlackLists < ActiveRecord::Migration
  def change
    create_table :black_lists do |t|
      t.references :user
      t.timestamps null: false
    end
  end
end
