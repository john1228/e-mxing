class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :sku #课程SKU码

      t.integer :course_id #对应课程ID
      t.integer :course_type #课程类型
      t.string :course_name #课程封面
      t.string :course_cover #课程封面
      t.integer :course_guarantee #是否担保

      t.string :seller #售课者到名字
      t.integer :seller_id #售课者ID

      t.decimal :market_price #市场价
      t.decimal :selling_price #销售价
      t.integer :store, default: -1 #库存数量
      t.integer :limit, default: -1 #限制购买数量
      t.string :address #地址
      t.st_point :coordinate, :geographic => true #地址对应坐标

      #缓存数量
      t.integer :comments_count, default: 0
      t.integer :orders_count, default: 0
      t.integer :concerns_count, default: 0
      #是否上下架
      t.integer :status, default: 0

      t.timestamps null: false
    end
    add_index :skus, :sku, unique: true
    add_index :skus, :coordinate, using: :gist
  end
end
