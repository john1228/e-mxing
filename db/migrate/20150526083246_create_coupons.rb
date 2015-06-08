class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :no #券号
      t.string :name #名称
      t.decimal :discount #抵价
      t.text :info #描述信息
      t.date :start_date #開始時間
      t.date :end_date #结束时间

      t.string :limit_category #优惠范围(通用,限制私教,限制产品,限制服务号)
      t.string :limit_ext #优惠范围对应到ID
      t.string :min #限制订单
      t.boolean :active #是否启用
      t.timestamps null: false
    end
  end
end
