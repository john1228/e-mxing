class CreateHActivityIntros < ActiveRecord::Migration
  def change
    create_table :h_activity_intros do |t|
      t.string :title
      t.string :instruction
      t.string :image, array: true, default: []
    end
  end
end
