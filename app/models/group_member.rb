class GroupMember < ActiveRecord::Base
  include GroupMemberConcern
  ADMIN = 0
end
