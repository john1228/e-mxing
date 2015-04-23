class AddRole < ActiveRecord::Migration
  def change
    add_column :admin_users, :role, :integer
    add_column :admin_users, :service_id, :integer
  end
end
