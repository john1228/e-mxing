class ChangeCommentTable < ActiveRecord::Migration
  def change
    # remove_column :comments, :prof
    # remove_column :comments, :punc
    # remove_column :comments, :space
    # remove_column :comments, :comm
    # remove_column :comments, :course_id
    # add_column :comments, :score, :integer
    # add_column :comments, :sku, :string
    add_column :skus, :course_type, :integer
    add_column :skus, :course_name, :string
    add_column :skus, :course_cover, :string
    add_column :skus, :course_guarantee, :integer, default: 0
    #缓存数量
    add_column :skus, :comments_count, :integer, default: 0
    add_column :skus, :orders_count, :integer, default: 0
    add_column :skus, :concerns_count, :integer, default: 0
  end
end
