class ChangeCommentTable < ActiveRecord::Migration
  def change
    # remove_column :comments, :prof
    # remove_column :comments, :punc
    # remove_column :comments, :space
    # remove_column :comments, :comm
    # remove_column :comments, :course_id
    # add_column :comments, :score, :integer
    # add_column :comments, :sku, :string

    add_column :skus, :status, :integer, default: 0
  end
end
