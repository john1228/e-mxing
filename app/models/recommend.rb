class Recommend < ActiveRecord::Base
  self.inheritance_column = nil
  TYPE = {person: 1, course: 2}
  class << self
    def remove(object)
      if object.is_a?(Course)
        Recommend.destroy_all(type: TYPE[:person], recommended_id: object.id)
      elsif object.is_a?(Coach)
        Recommend.destroy_all(type: TYPE[:course], recommended_id: object.id)
      end
    end
  end
end
