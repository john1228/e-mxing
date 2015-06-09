class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.references :user
      t.decimal :balance, default: 0
      t.string :coupons, default: ''
      t.integer :bean, default: 0
    end
  end
end
