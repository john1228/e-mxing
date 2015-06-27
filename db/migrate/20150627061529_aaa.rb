class Aaa < ActiveRecord::Migration
  def change
    add_column :lessons, :order_no, :string
    add_column :lessons, :contact_name, :string
    add_column :lessons, :contact_phone, :string
  end
end
