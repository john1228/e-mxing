class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.references :user
      t.string :tag
    end

    remove_column :withdraws,:amount
    add_column :withdraws,:amount,:decimal,default: 0
  end
end
