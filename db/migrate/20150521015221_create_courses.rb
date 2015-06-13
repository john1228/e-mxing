class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.references :coach #教练
      t.string :name #课程名
      t.integer :type #课程类型
      t.string :style #教学方式
      t.integer :during #课时长度
      t.integer :price #单课时价格
      t.string :exp #有效期
      t.integer :proposal #建议课时
      t.integer :guarantee, default: 0 #是否担保
      t.text :intro #课程介绍
      t.string :address #课程地址

      t.boolean :customized #是否定制课程
      t.string :custom_mxid #定制用户美型ID
      t.string :custom_mobile #定制用户手机号
      t.integer :top #是否设置为推荐课程
      t.integer :status, default: 0
      t.timestamps null: false
    end
  end
end
