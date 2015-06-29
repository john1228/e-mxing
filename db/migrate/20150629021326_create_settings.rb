class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :user
      t.integer :stealth #隐身设置
    end
    add_column :courses, :comments_count, :integer, default: 0
    add_column :courses, :concerns_count, :integer, default: 0
    add_column :courses, :order_items_count, :integer, default: 0
  end
end
