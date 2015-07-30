class CreateCompanyCoaches < ActiveRecord::Migration
  def change
    create_table :company_coaches do |t|
      t.references :company
      t.references :coach
      t.timestamps null: false
    end
  end
end
