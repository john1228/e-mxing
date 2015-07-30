class ChangeTablesForV3 < ActiveRecord::Migration
  def change
    add_column :order_items, :sku, :string
    add_column :lessons, :sku, :string
    add_column :appointments, :sku, :string

    add_column :courses, :special, :text, default: ''
    add_column :profiles, :service, :integer, array: true, default: []
    add_column :skus
  end
end
