class AddColumn < ActiveRecord::Migration
  def change
    add_column :orders, :order_type, :integer
    add_column :orders, :giveaway, :integer
  end
end
