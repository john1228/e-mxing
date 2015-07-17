class CreateGalleryImages < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
      t.references :gallery
      t.string :image
      t.text :caption, default: ''
    end
  end
end
