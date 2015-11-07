class StrategyComment < ActiveRecord::Base
  belongs_to :strategy, dependent: :destroy, counter_cache: :comment_count
  belongs_to :user
end
