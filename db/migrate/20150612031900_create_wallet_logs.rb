class CreateWalletLogs < ActiveRecord::Migration
  def change
    create_table :wallet_logs do |t|
      t.references :wallet
      t.integer :action #动作
      t.integer :balance
      t.string :coupons
      t.integer :bean
      t.timestamps null: false
    end
  end
end
