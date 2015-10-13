namespace :migration do
  desc '课程转移'
  task :course => :environment do
    i = 1
    Course.all.map { |course|
      old_sku = Sku.where("sku LIKE 'CC%'").find_by(course_id: course.id)
      coach = Coach.find_by(id: course.coach_id)
      service = coach.service rescue nil
      if service.present?
        ServiceCourse.create(
            name: course.name,
            image: course.image,
            type: course.type,
            style: course.style,
            during: course.during,
            proposal: course.proposal,
            exp: course.exp,
            intro: course.intro,
            special: '',
            agency: service.id,
            coach: coach.id,
            market_price: course.price,
            selling_price: course.price,
            store: -1,
            limit: -1,
        )
        sleep(5)
        new_sku = Sku.where("sku LIKE 'SC%'").where(service_id: service.id, seller_id: coach.id, course_name: course.name).last
        new_sku.update_attributes(course_guarantee: old_sku.course_guarantee, comments_count: old_sku.comments_count, orders_count: old_sku.orders_count, concerns_count: old_sku.concerns_count)

        OrderItem.where(sku: old_sku.sku).update_all(sku: new_sku.sku, cover: new_sku.course_cover)
        Lesson.where(sku: old_sku.sku).update_all(sku: new_sku.sku)
        Appointment.where(sku: old_sku.sku).update_all(sku: new_sku.sku)
        puts ++i
      end
    }
  end
end