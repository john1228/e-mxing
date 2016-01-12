class Category < ActiveRecord::Base
  mount_uploader :background, PhotosUploader

  def products(city)
    Product.includes(:sku, :card_type)
        .where('skus.address LIKE ?', "%#{city}%")
        .where(skus: {status: Sku.statuses['online']}, membership_card_types: {card_type: MembershipCardType.card_types['course'], value: item})
        .order('skus.selling_price asc')
  end
end
