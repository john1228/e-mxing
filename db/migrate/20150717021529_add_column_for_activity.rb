class AddColumnForActivity < ActiveRecord::Migration
  def change
    #add_column :activities, :pos, :integer, default: 0
    add_index :profiles, :identity
    add_index :dynamics, :user_id
  end
end
