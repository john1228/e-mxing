class CourseAddress < ActiveRecord::Base
  belongs_to :course
  belongs_to :address
end
