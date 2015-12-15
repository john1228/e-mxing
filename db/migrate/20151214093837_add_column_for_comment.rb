class AddColumnForComment < ActiveRecord::Migration
  def change
    change_column :schedules, :sku_id, :string, default: ''
    add_column :schedules, :remark, :string, default: ''
    add_column :comments, :coach_id, :integer, default: 0
    add_column :schedules, :user_type, :integer, default: 0
  end
end
