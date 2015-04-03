class GroupMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  ADMIN = 0

  def as_json
    user.summary_json
  end
end
