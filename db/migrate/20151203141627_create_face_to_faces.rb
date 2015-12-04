class CreateFaceToFaces < ActiveRecord::Migration
  def change
    create_table :face_to_faces do |t|
      t.references :sku
      t.string :name
      t.string :avatar
      t.string :mobile
      t.string :amount
      t.integer :pay_amount
      t.integer :pay_type
      t.timestamps null: false
    end
  end
end
