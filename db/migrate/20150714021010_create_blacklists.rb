class CreateBlacklists < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.references :user
      t.timestamps null: false
    end
  end
end
