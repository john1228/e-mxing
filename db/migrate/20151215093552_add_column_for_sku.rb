class AddColumnForSku < ActiveRecord::Migration
  def change
    #add_column :skus, :sku_type, :integer, default: 0

    #add_index :skus, :sku_type
    remove_column :schedules, :user_name
  end
end
