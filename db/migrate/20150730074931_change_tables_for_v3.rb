class ChangeTablesForV3 < ActiveRecord::Migration
  def change
    add_column :order_items, :sku, :string
    add_column :lessons, :sku, :string
    add_column :appointments, :sku, :string
  end
end
