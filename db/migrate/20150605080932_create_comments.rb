class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :course
      t.string :content
      t.integer :prof
      t.integer :comm
      t.integer :punc
      t.integer :space
      t.timestamps null: false
    end
  end
end
