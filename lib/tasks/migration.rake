namespace :migration do
  desc '课程转移'
  task :course => :environment do
    Course.all.map { |course|
      service = course.coach.service

      Sku.create(
          sku: 'CC'+'-' + '%06d' % course.id + '-' + '%06d' % (service.id),
          course_id: course.id,
          seller: course.coach.name,
          seller_id: course.coach.id,
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
      if course.present?
        item.update(price: course.price, sku: Sku.find_by(course_id: course.id).sku) unless course.present?
      else
        item.destroy
      end

    }
  end

  desc '课时转移'
  task :lessons => :environment do
    Lesson.all.map { |lesson|
      course = Course.find_by(id: lesson.course_id)
      if course.present?
        lesson.update(sku: Sku.find_by(course_id: course.id).sku)
      else
        lesson.destroy
      end
    }
  end
end