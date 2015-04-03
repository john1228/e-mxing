class CreateCaptchas < ActiveRecord::Migration
  def change
    create_table :captchas do |t|
      t.string :mobile
      t.string :captcha

      t.timestamps null: false
    end
  end
end
