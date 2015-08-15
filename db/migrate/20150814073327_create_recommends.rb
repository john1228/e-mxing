class CreateRecommends < ActiveRecord::Migration
  def change
    # create_table :recommends do |t|
    #   t.integer :type
    #   t.integer :recommended_id
    #   t.text :recommended_tip
    #   t.timestamps null: false
    # end
    add_column :orders, :service_id, :integer
  end
end
