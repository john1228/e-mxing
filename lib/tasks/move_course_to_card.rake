namespace :move_course_to_card do
  task :move => :environment do
    Sku.course.offset(2).order(updated_at: :desc).map { |sku_course|
      puts sku_course.sku
      #创建会员卡类型
      Sku.transaction do
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
          product.build_prop(
              during: sku_course.course.during,
              proposal: sku_course.course.proposal,
              style: sku_course.course.style
          )
          if product.save
            #更新关注数据
            Concerned.where(sku: sku_course.sku).update_all(sku: product.sku.id)
            #更新订单数据
            OrderItem.where(sku: sku_course.sku).update_all(sku: product.sku.id)
            product.sku.update(status: sku_course.status)
          end
          #把原来的课程更换城会员卡
          Lesson.where(sku: sku_course.sku).map { |lesson|
            user = lesson.user
            member = Member.find_by(user_id: user.id, service_id: sku_course.service_id)
            if member.blank?
              member = Member.new(
                  client_id: sku_course.service.client_id,
                  service_id: sku_course.service.id,
                  user_id: user.id,
                  name: lesson.contact_name,
                  mobile: lesson.contact_phone
              )
            end
            membership_card = MembershipCard.course.new(
                order_id: lesson.order_id,
                member_id: member.id,
                name: lesson.order.order_item.name,
                value: lesson.available,
                open: lesson.appointments.last.created_at,
                valid_days: lesson.order.order_item,
                status: 'normal'
            )
            if membership_card.save
              lesson.appointments.each { |appointment|
                membership_card.logs.mx.create(
                    change_amount: appointment.amount,
                    operator: (appointment.coach.profile.name rescue ''),
                    remark: "消课码-#{appointment.code}",
                )
              }
            end
          }
        end
      end
    }
  end
end
