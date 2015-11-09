class Strategy < ActiveRecord::Base
  belongs_to :user
  has_many :comments, class: StrategyComment
end
