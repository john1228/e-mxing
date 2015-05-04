class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :mobile
      t.string :sns
      t.string :password
      t.string :salt
      t.timestamps
    end
  end
end
