namespace :move_course_to_card do
  task :move => :environment do
    Sku.course.map { |sku_course|
      course = sku_course.course

    }
  end
end
