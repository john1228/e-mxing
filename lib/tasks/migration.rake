namespace :migration do
  desc '课程转移'
  task :course => :environment do
    Course.all.map { |course|
      service = course.coach.service
      Sku.create(
          sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
          market_price: course.price,
          selling_price: course.price,
          address: service.address||'',
          coordinate: (service.place.lonlat rescue 'POINT(0 0)')
      ) if service.present?
    }
  end

  desc '订单转移'
  task :orders => :environment do
    OrderItem.all.map { |item|
      course = Course.find_by(id: item.course_id)
      OrderItem.update(price: course.price, sku: Sku.find_by(course_id: course.id).sku)
    }
  end

  desc '课程转移'
  task :course => :environment do
    Course.all { |course|
      service = course.coach.service
      Sku.create(
          sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
          market_price: course.price,
          selling_price: course.price,
          address: service.address||'',
          coordinate: (service.place.lonlat rescue 'POINT(0 0)')
      ) if service.present?
    }
  end

  desc '课程转移'
  task :course => :environment do
    Course.all { |course|
      service = course.coach.service
      Sku.create(
          sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
          market_price: course.price,
          selling_price: course.price,
          address: service.address||'',
          coordinate: (service.place.lonlat rescue 'POINT(0 0)')
      ) if service.present?
    }
  end
end