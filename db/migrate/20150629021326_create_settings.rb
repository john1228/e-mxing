class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :user
      t.integer :stealth #隐身设置
    end
    remove_column :courses, :order_items_count
    add_column :courses, :order_items_count, :integer, default: 0
  end
end
