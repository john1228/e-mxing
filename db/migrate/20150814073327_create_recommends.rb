class CreateRecommends < ActiveRecord::Migration
  def change
    # create_table :recommends do |t|
    #   t.integer :type
    #   t.integer :recommended_id
    #   t.text :recommended_tip
    #   t.timestamps null: false
    # end
    # add_column :orders, :service_id, :integer
    # add_column :coupons, :code, :string, array: true, default: []
    
    add_column :coupons, :amount, :integer, default: 0
    add_column :coupons, :lock_version, :integer, default: 0
  end
end
