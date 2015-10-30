class Tag < ActiveRecord::Base
  enum tag: [:venues, :course, :dynamic, :news]
end