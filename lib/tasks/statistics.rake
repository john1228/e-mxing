namespace :st do
  desc '计算应用概况'
  task :overview => :environment do
    report_date = Date.today
    activation = Device.where(created_at: report_date.yesterday...report_date).count
    register = User.where(created_at: report_date.yesterday...report_date).count
    activity = AutoLogin.select(:device).where(created_at: report_date.yesterday...report_date).uniq.count
    Overview.create(report_date: report_date, activation: activation, register: register, activity: activity)
  end

  desc '计算留存率'
  task :month => :environment do
    report_date = Date.today
    register = User.where(created_at: report_date.yesterday...report_date).pluck(:id)
    day_one =
    day_three = 50
    day_seven = 70
    Retention.create(report_date: report_date, register: register, day_one: day_one, day_three: day_three, day_seven: day_seven)
  end
end