class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :no #交易流水号
      t.string :order_no #订单号
      t.string :source #交易方
      t.string :buyer_id
      t.string :buyer_email
      t.decimal :price
      t.timestamps null: false
    end
  end
end
