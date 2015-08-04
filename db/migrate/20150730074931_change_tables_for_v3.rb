class ChangeTablesForV3 < ActiveRecord::Migration
  def change
    # add_column :order_items, :sku, :string
    # add_column :lessons, :sku, :string
    # add_column :appointments, :sku, :string
    #
    # add_column :courses, :special, :text, default: ''
    # add_column :profiles, :service, :integer, array: true, default: []
    #

    #add_column :appointments, :code, :string
    #add_index :appointments, :code, unique: true
    #drop_table :appoint_logs
    #add_column :lessons, :code, :string, array: true, default: []
    
    add_column :concerneds, :sku, :string
  end
end
