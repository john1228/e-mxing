class Heel < ActiveRecord::Migration
  def change
    remove_column :wallets, :coupons
    add_column :wallets, :coupons, :integer, array: true, default: []
    remove_column :courses, :exp
    add_column :coupons, :exp, :integer, default: 365
  end
end
