class AddColumnForActivity < ActiveRecord::Migration
  def change
    #add_column :activities, :pos, :integer, default: 0
    remove_column :withdraws, :amount
    add_column :withdraws, :amount, :decimal, default: 0
  end
end
