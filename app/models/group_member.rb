class GroupMember < ActiveRecord::Base
  include GroupMemberAble
  ADMIN = 0
  APPLY = -1
  MEMBER = 1
end
