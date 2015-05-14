class CreateCoachDocs < ActiveRecord::Migration
  def change
    create_table :coach_docs do |t|
      t.references :coach
      t.string :image
    end
  end
end
