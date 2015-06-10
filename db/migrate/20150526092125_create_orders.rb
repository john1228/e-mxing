class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user
      t.references :coach
      t.string :no #订单编号
      t.string :coupons #优惠券编号
      t.string :bea
      t.string :contact_name #联系人
      t.string :contact_phone #联系电话
      t.string :pay_type #支付类型
      t.decimal :total #总价
      t.decimal :pay_amount, default: 0 #已支付
      t.string :status #订单状态

      t.timestamps null: false
    end
  end
end
