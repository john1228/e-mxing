namespace :migration do
  desc '课程转移'
  task :course => :environment do
    Course.all.map { |course|
      coach = Coach.find_by(id: course.coach_id)
      service = coach.service rescue nil
      if service.present?
        course = ServiceCourse.create(
            name: course.name,
            image: course.image,
            type: course.type,
            style: course.style,
            during: course.during,
            proposal: course.proposal,
            exp: course.exp,
            intro: course.intro.blank? ? '暂无介绍' : course.intro,
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

  task :order_item => :environment do
    OrderItem.where('sku LIKE ?', 'CC%').each { |item|
      puts item.sku
      old_sku = Sku.find_by(sku: item.sku)
      new_sku = Sku.where("sku LIKE ?", 'SC%').find_by(seller_id: old_sku.seller_id, course_name: old_sku.course_name, selling_price: old_sku.selling_price, course_type: old_sku.course_type)
      new_sku.update(course_cover: old_sku.course_cover)
      item.update(sku: new_sku.sku)
      Lesson.where(sku: item.sku).update_all(sku: new_sku.sku)
      Appointment.where(sku: item.sku).update_all(sku: new_sku.sku)
      Comment.where(sku: item.sku).update_all(sku: new_sku.sku)
      Concerned.where(sku: item.sku).update_all(sku: new_sku.sku)
    }
  end

  task :profile => :environment do
    Profile.service.where('address LIKE ?', '上海市%').each { |profile|
      address = profile.address
      puts address
      begin
        province = '上海市'
        city = address[0, address.index('市')+1]
        area = address.index('区')
        if area.blank?
          area = ''
          detail_address = address[address.index('市')+1, address.length]
        else
          area = address[address.index('市')+1, address.index('区')-address.index('市')]
          detail_address = address[address.index('区')+1, address.length]
        end
        profile.update(province: province,
                       city: city,
                       area: area,
                       address: detail_address,
                       hobby: profile.interests.blank? ? [30] : profile.interests.split(','),
                       mobile: profile.mobile.blank? ? '021-62418505' : profile.mobile,
                       signature: profile.signature.blank? ? '暂无简介' : profile.signature,
        )
      rescue Exception => exp
        puts exp.message
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
      begin
        sku = Sku.find_by(seller_id: item.order.coach_id, course_name: item.name)
        item.order.update(service_id: sku.service_id)
        item.update(sku: sku.sku)
        Lesson.where(sku: item.sku).update_all(sku: sku.sku)
        Appointment.where(sku: item.sku).update_all(sku: sku.sku)
        Comment.where(sku: item.sku).update_all(sku: sku.sku)
        Concerned.where(sku: item.sku).update_all(sku: sku.sku)
      rescue
      end
    }
  end

  task :update_other => :environment do
    Concerned.where("sku LIKE 'CC%'").each { |item|
      sku = item.sku.split('-')
      course = Course.find_by(id: sku[1])
      item.destroy if course.nil?

      begin
        sku = Sku.find_by(seller_id: course.coach_id, course_name: course.name)
        Concerned.where(sku: item.sku).update_all(sku: sku.sku)
      rescue
      end
    }
    //
  end
end