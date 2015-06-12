class ChangeTables < ActiveRecord::Migration
  def change
    #预约添加字段
    remove_column :appointments, :track_id, :integer
    remove_column :appointments, :created_at, :datetime
    remove_column :appointments, :updated_at, :datetime

    add_column :appointments, :coach_id, :integer #教练编号
    add_column :appointments, :course_id, :integer #预约到课程编号
    add_column :appointments, :course_name, :string #课程名字
    add_column :appointments, :course_during, :string #课程长度
    add_column :appointments, :classes, :integer #课程节数
    add_column :appointments, :date, :date #预约日期
    add_column :appointments, :start_time, :string #预约开始时间
    add_column :appointments, :venues, :string #预约场馆
    add_column :appointments, :address, :string #预约地址
    add_column :appointments, :online, :string #在线预约者(以逗号分开)
    add_column :appointments, :offline, :string #线下预约者
    add_column :appointments, :status, :string
  end
end
