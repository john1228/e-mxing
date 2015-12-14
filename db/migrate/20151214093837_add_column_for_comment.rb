class AddColumnForComment < ActiveRecord::Migration
  def change
    add_column :comments, :coach_id, :integer, default: 0
  end
end
