class CreateCompanyShops < ActiveRecord::Migration
  def change
    create_table :company_shops do |t|
      t.references :company
      t.integer :shop_id
      t.timestamps null: false
    end
  end
end
