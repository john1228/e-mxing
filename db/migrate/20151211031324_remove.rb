class Remove < ActiveRecord::Migration
  def change
    drop_table :set_offs
    change_column :schedules, :sku_id, :string, default: ''
    add_column :schedules, :remark, :string, default: ''
  end
end
