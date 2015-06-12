class ChangeTracksTable < ActiveRecord::Migration
  def change
    add_column :order_items, :during, :integer
  end
end
