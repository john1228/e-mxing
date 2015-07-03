class AddIndex < ActiveRecord::Migration
  def change
     add_index :users, [:mobile,:sns], unique: true
     change_column_default :users,:mobile,''
     change_column_default :users,:sns,''
  end
end
