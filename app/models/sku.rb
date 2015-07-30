class Sku < ActiveRecord::Base
  belongs_to :valid

  def as_json
    {
        sku: sku,
        name: course.name,
        cover: course.cover,
        selling: selling_price,
        address: address,
    }
  end

  def detail
    {
        sku: sku,
        name: course.name,
        images: course.images,
        market: market_price,
        selling: selling_price,
        type: course.type,
        style: course.style,
        proposal: course.proposal,

    }
  end

  def seller

  end

  def course
    if sku.start_with?('SC')
      ServiceCourse.find_by(id: course_id)
    else
      Course.find_by(id: course_id)
    end
  end

  private
  def seller

  end
end
