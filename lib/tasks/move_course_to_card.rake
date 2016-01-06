namespace :move_course_to_card do
  task :move => :environment do
    Sku.course.map { |sku_course|
      #创建会员卡类型
      card_type = MembershipCardType.course.new(
          name: sku_course.course.name,
          service_id: sku_course.service_id,
          price: sku_course.market_price,
          value: sku_course.course.type,
          valid_days: sku_course.course.exp,
          remark: '课程卡'
      )
      #创建出售会员卡
      if card_type.save
        product = Product.new(
            name: sku_course.course.name,
            card_type_id: card_type.id,
            image: sku_course.course.image,
            description: sku_course.course.intro,
            special: sku_course.course.special,
            service_id: sku_course.service_id,
            market_price: sku_course.market_price,
            selling_price: sku_course.selling_price,
            store: sku_course.store || -1,
            limit: sku_course.limit || -1,
            seller_id: sku_course.seller_id
        )
        if product.save
          #更新关注数据
          Concerned.where(sku: sku_course.sku).update_all(sku: product.sku.id)
          #更新订单数据
          OrderItem.where(sku: sku_course.sku).update_all(sku: product.sku.id)
        end
        #把原来的课程更换城会员卡
        Lesson.where(sku: sku_course.sku).map{|lesson|
          MembershipCard.new()
        }
        Appointment.where(sku: sku_course.sku).update_all(sku: product.sku.id)
      end
    }
  end
end
