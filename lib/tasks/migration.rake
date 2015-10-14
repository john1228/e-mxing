namespace :migration do
  desc '课程转移'
  task :course => :environment do
    Course.all.map { |course|
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
      end
    }
  end


  task :relation => :environment do
    Course.all.map { |course|
      old_sku = Sku.where("sku LIKE 'CC%'").find_by(course_id: course.id)
      coach = Coach.find_by(id: course.coach_id)
      service = coach.service rescue nil
      if service.present?
        new_sku = Sku.where("sku LIKE 'SC%'").where(service_id: service.id, seller_id: coach.id, course_name: course.name).last
        new_sku.update_attributes(status: old_sku.status, course_guarantee: old_sku.course_guarantee, comments_count: old_sku.comments_count, orders_count: old_sku.orders_count, concerns_count: old_sku.concerns_count)

        OrderItem.where(sku: old_sku.sku).update_all(sku: new_sku.sku, cover: new_sku.course_cover)
        Lesson.where(sku: old_sku.sku).update_all(sku: new_sku.sku)
        Appointment.where(sku: old_sku.sku).update_all(sku: new_sku.sku)
      end
    }
  end

  task :sku => :environment do
    Sku.where("sku LIKE 'SC%'").where(service_id: nil).map { |sku|
      sku.update(service_id: sku.seller_id)
    }
  end

  task :sku_delete => :environment do
    Sku.where("sku LIKE 'CC%'").map { |sku|
      sku.destroy
    }
  end

  task :update_cc => :environment do
    OrderItem.where("sku LIKE 'CC%'").each { |item|
      sku = Sku.find_by(service_id: item.order.service_id, :seller_id => item.order.coach_id, course_name: item.name)
      item.update(sku: sku.sku)
      Lesson.where(sku: item.sku).update_all(sku: sku.sku)
      Appointment.where(sku: item.sku).update_all(sku: sku.sku)
    }
  end

end