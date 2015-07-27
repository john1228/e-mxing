class ServiceCourse < ActiveRecord::Base
  STATUS = {offline: 0, online: 1}
  has_many :skus, foreign_key: :course_id, dependent: :destroy
  after_save :build_skus
  attr_accessor :agency, :market_price, :selling_price, :store, :limit, :images


  private
  def build_skus
    skus.destroy_all
    agencies = Service.where(id: agency)
    agencies.each { |agency|
      skus.new(
          sku: 'SC' + '%08d' % id,
          market_price: market_price,
          selling_price: selling_price,
          store: store,
          limit: limit,
          address: agency.address,
          coordinate: agency.place.lonlat
      )
    }
  end
end
