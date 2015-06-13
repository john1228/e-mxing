class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true #订单
      t.references :course #
      t.string :name #订单商品名城
      t.integer :type #订单商品
      t.string :cover #订单商品封面
      t.string :price #订单商品价格
      t.integer :amount #订单商品数量
      t.timestamps null: false
    end
  end
end
