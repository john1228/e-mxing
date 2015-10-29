class ChangeDbForV33 < ActiveRecord::Migration
  def change
    #删除旧版本无用到表
    drop_table :address_coordinates
    drop_table :addresses
    drop_table :captchas
    drop_table :course_abstracts
    drop_table :galleries
    drop_table :gallery_images
    drop_table :expiries
    drop_table :tracks
    drop_table :type_shows
    #给用户加上认证和标签
    add_column :profiles, :auth, :integer, default: 0
    add_column :profiles, :tag, :string, array: true, default: []
    #给新闻资讯加上标签
    add_column :news, :tag_1, :string, array: true, default: []
  end
end
