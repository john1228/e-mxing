namespace :sms do
  desc '计算周like榜'
  task :message => :environment do
    Lesson.where(sku: 'SC-000030-046378').each { |lesson|
      puts lesson.order.contact_phone
      SmsJob.perform_later(lesson.order.contact_phone, SMS['群发'], [lesson.code.first])
    }
  end
end