module FindManager
  extend ActiveSupport::Concern
  private
  def dynamics
    Dynamic.order(id: :desc).includes(:user, :dynamic_images, :dynamic_film).page(params[:page]||1).collect { |dynamic|
      {
          dynamic: dynamic.as_json,
          user: dynamic.user.profile.summary_json
      }
    }
  end

  def persons
    filters = '1=1'
    filters << " and profiles.gender=#{params[:gender]}" unless params[:gender].blank?||params[:gender].eql?('-1')
    if params[:identity].eql?('0')
      filters << " and profiles.identity=#{params[:identity]}"
    elsif params[:identity].eql?('1')
      filters << " and profiles.identity=#{params[:identity]}"
    else
      filters << ' and profiles.identity!=2'
    end
    #过滤隐身的用户
    streams = Setting.where(stealth: Setting::STEALTH).pluck(:user_id)
    filters << " and profiles.user_id not in (#{streams.join(',')})" unless streams.blank?
    Place.nearby(params[:lng], params[:lat], filters, params[:page]||1).collect { |place| place.nearby_user_json }
  end

  def groups
    {
        recommend: Group.recommend.limit(2).collect { |group| group.as_json },
        nearby: GroupPlace.nearby(params[:lng], params[:lat]).page(params[:page]).collect { |group_place|
          group_place.group.as_json.merge(distance: group_place.distance.to_i)
        }
    }
  end

  def services
    Place.nearby_services(params[:lng], params[:lat], params[:page]||1).collect { |place| place.nearby_user_json }
  end

  def news
    News.order(id: :desc).page(params[:page]||1).collect { |news| news.as_json }
  end

  def activities
    Activity.order(id: :desc).page(params[:page]||1).collect { |activity| activity.as_json }
  end

  def shows
    TypeShow.order(id: :desc).page(params[:page]||1).collect { |show| show.as_json }
  end

  def ranks
    week_rank = (Rails.cache.fetch('week')||{})
    week_rank.delete_if { |k, v| User.find_by(id: k).blank? }
    month_rank = (Rails.cache.fetch('month')||{})
    month_rank.delete_if { |k, v| User.find_by(id: k).blank? }
    {
        week: {
            week: Date.today.strftime('%U').to_i,
            items: week_rank.map { |k, v|
              user = User.find_by(id: k)
              {user: user.summary_json, likes: v} if user.present? }
        },
        month: {
            items: month_rank.map { |k, v|
              user = User.find_by(id: k)
              {user: user.summary_json, likes: v} if user.present? }
        }
    }
  end

  def courses
    filter = '1=1'
    filter << " and course_abstracts.course_type=#{params[:course].to_i}" if params[:course].present?
    if params[:coach].eql?('male')||params[:coach].eql?('female')
      gender = params[:coach].eql?('male') ? 0 : 1
      filter << " and course_abstracts.coach_gender=#{gender}"
    end
    if params[:price].present?
      price_range = params[:price].split('~')
      if price_range[1].blank?
        filter << " and course_abstracts.course_price > #{price_range[0].to_i}"
      else
        filter << " and course_abstracts.course_price between #{price_range[0].to_i} and #{price_range[1].to_i}"
      end
    end

    case params[:sort]
      when 'price-asc'
        results = CourseAbstract.select(:course_id, :course_price).where(filter).order(course_price: :asc).uniq.page(params[:page]||1)
      when 'price-desc'
        results = CourseAbstract.select(:course_id, :course_price).uniq.where(filter).order(course_price: :desc).uniq.page(params[:page]||1)
      when 'distance-asc'
        results = CourseAbstract.select("course_id, st_distance(course_abstracts.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') distance").where("st_dwithin(course_abstracts.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})',15000000) and #{filter}").uniq.order('distance asc').page(params[:page]||1)
      when 'sale-desc'
        results = CourseAbstract.select(:course_id, :course_price).includes(:course).where(filter).order('courses.order_items_count desc').uniq.page(params[:page]||1)
      else
        results = []
    end


    results.map { |course_abstract|
      course = course_abstract.course
      {
          id: course.id,
          name: course.name,
          cover: course.course_photos.first.present? ? course.course_photos.first.photo.thumb.url : '',
          price: course.price,
          during: course.during,
          type: course.type,
          style: course.style,
          top: course.top,
          guarantee: course.guarantee,
          concerned: course.concerns_count
      }
    }
  end
end
