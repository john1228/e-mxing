class ChangeColumnForProfile < ActiveRecord::Migration
  def change
    # add_column :profiles, :hobby, :integer, array: true, default: []
    # add_column :profiles, :province, :string
    # add_column :profiles, :city, :string
    add_column :skus, :service_id, :integer
  end
end
