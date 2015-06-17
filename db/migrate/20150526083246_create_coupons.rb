class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :no #券号
      t.string :name #名称
      t.decimal :discount #抵价
      t.text :info #描述信息
      t.date :start_date #開始時間
      t.date :end_date #结束时间

      t.integer :limit_category, default: 1 #优惠范围(通用,限制私教,限制产品,限制服务号),
      t.integer :limit_ext, default: 0 #优惠范围对应到ID
      t.integer :min, default: 0 #限制订单
      t.boolean :active #是否启用
      t.timestamps null: false

      change_column :coupons,:limit_category,:integer
    end
  end
end
