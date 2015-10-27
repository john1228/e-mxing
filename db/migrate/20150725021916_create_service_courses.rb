class CreateServiceCourses < ActiveRecord::Migration
  def change
    create_table :service_courses do |t|
      t.string :name, default: '' #名称
      t.integer :type, default: 0 #类型
      t.string :style, default: '' #教学方式
      t.integer :during #时长
      t.integer :proposal #建议时长
      t.integer :exp #有效期
      t.integer :guarantee, default: 0
      t.text :intro, default: '' #课程内容
      t.text :special, default: '' #特殊说明

      t.integer :service, array: true, default: [] #服务支持

      t.datetime :limit_start #限制上课开始时间
      t.datetime :limit_end #限制上课结束时间

      t.integer :status, default: 0 #状态 默认上架
      t.string :image, array: true, default: []

      t.timestamps null: false
      t.text :intro
    end
    #rename_column :service_courses,:info,:intro
  end
end
