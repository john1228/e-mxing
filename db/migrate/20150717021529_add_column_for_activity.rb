class AddColumnForActivity < ActiveRecord::Migration
  def change
    #add_column :activities, :pos, :integer, default: 0
    add_column :withdraws, :status, :integer, default: 0
  end
end
