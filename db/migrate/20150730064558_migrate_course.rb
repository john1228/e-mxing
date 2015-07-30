class MigrateCourse < ActiveRecord::Migration
  def change
    Course.all { |course|
      service = course.coach.service
      unless service.blank?
        Sku.create(
            sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
            market_price: course.price,
            selling_price: course.price,
            address: service.address||'',
            coordinate: (service.place.lonlat rescue 'POINT(0 0)')
        )
      end
    }
  end
end
