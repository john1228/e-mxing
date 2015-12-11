class Remove < ActiveRecord::Migration
  def change
    drop_table :set_offs
    #change_column :schedules, :sku_id, :string, default: ''
  end
end
