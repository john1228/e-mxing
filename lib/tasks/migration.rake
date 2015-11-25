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
    Profile.service.where('address LIKE ?', '南京市%').each { |profile|
      address = profile.address
      puts address
      begin
        address = profile.address
        province = '北京市'
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

  task :coach => :environment do
    results = Coach.all.map { |coach|
      profile = coach.profile
      if profile.update(
          province: coach.service.profile.province,
          city: coach.service.profile.city,
          area: coach.service.profile.area,
          address: coach.service.profile.address,
          hobby: profile.interests.blank? ? [30] : profile.interests.split(','),
          birthday: profile.birthday.blank? ? '1985-8-8' : profile.birthday
      )
        nil
      else
        profile.errors.messages
      end
    }
    results.compact!
    puts results
  end
end