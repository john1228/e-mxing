class ChangeCommentTable < ActiveRecord::Migration
  def change
    remove_column :comments, :prof
    remove_column :comments, :punc
    remove_column :comments, :space
  end
end
