class Lesson < ActiveRecord::Base
  belongs_to :user
  belongs_to :coach
  belongs_to :course
  belongs_to :order
  has_many :appointments

  class<<self
    def is_valid?(course)
      where('available > used and exp< ? and course_id', Date.today, course.id).present?
    end
  end
end
