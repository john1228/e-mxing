class ChangeTablesForV3 < ActiveRecord::Migration
  def change
    remove_column :order_items, :price
    add_column :order_items, :price, :integer
    add_column :order_items, :sku, :string

    add_column :lessons, :sku, :string
    add_column :appointments, :sku, :string
  end
end
