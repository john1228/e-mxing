class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id

      t.string :signature, default: ''

      t.string :name, default: ''
      t.string :avatar, default: ''
      t.integer :gender, default: 0
      t.integer :identity, default: 0
      t.date :birthday, default: Date.today.prev_year(16)
      t.string :address, default: ''
      #健身领域
      t.string :target, default: ''
      t.string :skill, default: ''
      t.string :often_stadium, default: ''
      t.string :interests, default: ''

      t.string :mobile, default: ''
    end
  end
end
