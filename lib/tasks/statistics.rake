namespace :st do
  desc '计算周like榜'
  task :overview => :environment do
    report_date = Date.today
    activation = Device.where(created_at: report_date.yesterday...report_date).count
    register = User.where(created_at: report_date.yesterday...report_date).count
    activity = 0
    Overview.create(report_date: report_date, activation: activation, register: register, activity: activity)
  end

  desc '计算月like榜'
  task :month => :environment do
    report_date = Date.today
    register = User.where(created_at: report_date.yesterday...report_date).pluck(:id)
    day_one = 30
    day_three = 50
    day_seven = 70
    Retention.create(report_date: report_date, day_one: day_one, day_three: day_three, day_seven: day_seven)
  end
end