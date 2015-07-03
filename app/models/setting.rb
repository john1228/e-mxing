class Setting < ActiveRecord::Base
  belongs_to :user

  STEALTH = 1
end
