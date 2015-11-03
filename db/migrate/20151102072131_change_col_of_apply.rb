class ChangeColOfApply < ActiveRecord::Migration
  def change
    add_column :applies, :name, :string
    add_column :applies, :gender, :integer, default: 0
    add_column :applies, :phone, :string
  end
end
