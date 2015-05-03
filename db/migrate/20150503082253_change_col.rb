class ChangeCol < ActiveRecord::Migration
  def change
    rename_column :users, :username, :mobile
    add_column :users, :sns, :string
    # User.all.map { |user|
    #   user.update(sns: user.mobile)
    #   user.update(mobile: user.profile.mobile)
    # }
    # remove_column :profiles, :mobile
  end


end
