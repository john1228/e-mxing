class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :sku #课程SKU码
      t.integer :course_id #对应课程ID
      t.string :seller #售课者到名字
      t.integer :seller_id #售课者ID
      t.integer :service, array: true, default: []
      t.decimal :market_price #市场价
      t.decimal :selling_price #销售价
      t.integer :store #库存数量
      t.integer :limit #限制购买数量
      t.string :address #地址
      t.st_point :coordinate, :geographic => true #地址对应坐标
      t.timestamps null: false
    end
    add_index :skus, :sku, unique: true
    add_index :skus, :coordinate, using: :gist
  end
end
