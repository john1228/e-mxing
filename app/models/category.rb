class Category < ActiveRecord::Base
  mount_uploader :background, PhotosUploader

  def products
    Product.includes(:sku, :card_type).where(skus: {status: 1}, membership_card_types: {card_type: 3, value: item}).order('skus.selling_price asc')
  end
end
