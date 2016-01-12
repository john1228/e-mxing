namespace :move_course_to_card do
  task :move_order => :environment do
    Order.pay.each { |order|
      membership_card = MembershipCard.find_by(order_id: order.id)
      if membership_card.blank?
        Order.transaction do
          user = order.user
          member = Member.find_by(user_id: user.id, service_id: order.service_id)
          if member.present?
            membership_card = MembershipCard.course.new(
                client_id: sku_course.service.client_id,
                service_id: sku_course.service.id,
                order_id: lesson.order_id,
                member_id: member.id,
                name: lesson.order.order_item.name,
                value: sku_course.course.type,
                supply_value: lesson.available,
                open: (lesson.appointments.last.created_at rescue ''),
                valid_days: lesson.order.order_item,
                status: 'normal'
            )
            if membership_card.save
              #创建充值日志
              membership_card.logs.mx.buy.create(
                  service_id: membership_card.service_id,
                  change_amount: appointment.amount,
                  operator: (appointment.coach.profile.name rescue ''),
                  remark: "购买课程",
                  action: MembershipCardLog.actions['buy'],
                  status: MembershipCardLog.statuses['confirm']
              )
            end
          else
            member = Member.new(user_id: user.id, name: order.contact_name, mobile: order.contact.phone)
            if member.save
              membership_card = MembershipCard.course.new(
                  client_id: sku_course.service.client_id,
                  service_id: sku_course.service.id,
                  order_id: lesson.order_id,
                  member_id: member.id,
                  name: lesson.order.order_item.name,
                  value: sku_course.course.type,
                  supply_value: lesson.available,
                  open: (lesson.appointments.last.created_at rescue ''),
                  valid_days: lesson.order.order_item,
                  status: 'normal'
              )
              if membership_card.save
                #创建充值日志
                membership_card.logs.mx.buy.create(
                    service_id: membership_card.service_id,
                    change_amount: appointment.amount,
                    operator: (appointment.coach.profile.name rescue ''),
                    remark: "购买课程",
                    action: MembershipCardLog.actions['buy'],
                    status: MembershipCardLog.statuses['confirm']
                )
              end
            end
          end
        end
      end
    }
  end

  task :move => :environment do
    Sku.where('sku like ?', 'SC%').where('updated_at < ?', Sku.find('SC-000517-000023').updated_at).order(updated_at: :desc).map { |sku_course|
      puts sku_course.sku
      next if sku_course.course.blank?
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
            member = Member.create(
                client_id: sku_course.service.client_id,
                service_id: sku_course.service.id,
                user_id: user.id,
                name: lesson.contact_name,
                mobile: lesson.contact_phone
            ) if member.blank?

            membership_card = MembershipCard.course.new(
                client_id: sku_course.service.client_id,
                service_id: sku_course.service.id,
                order_id: lesson.order_id,
                member_id: member.id,
                name: lesson.order.order_item.name,
                value: sku_course.course.type,
                supply_value: lesson.available,
                open: (lesson.appointments.last.created_at rescue ''),
                valid_days: lesson.order.order_item,
                status: 'normal'
            )
            if membership_card.save
              #创建充值日志

              #创建签到日志
              lesson.appointments.each { |appointment|
                membership_card.logs.mx.create(
                    service_id: membership_card.service_id,
                    change_amount: appointment.amount,
                    operator: (appointment.coach.profile.name rescue ''),
                    remark: "消课码-#{appointment.code}",
                    action: MembershipCardLog.actions['checkin'],
                    status: MembershipCardLog.statuses['confirm']
                )
              }
            end
          }
        end
      end
    }
  end
end
