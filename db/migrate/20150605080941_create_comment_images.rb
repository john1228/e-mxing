class CreateCommentImages < ActiveRecord::Migration
  def change
    create_table :comment_images do |t|
      t.references :comment
      t.string :image
    end
  end
end
