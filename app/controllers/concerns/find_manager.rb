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
    filters << " and profiles.gender=#{params[:gender]}" unless params[:gender].blank?||params[:gender].eql?("-1")
    filters << " and profiles.identity=#{params[:identity]}" unless params[:identity].blank?||params[:identity].eql?("-1")
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
    week_rank = Rails.cache.fetch('week')||{}
    month_rank = Rails.cache.fetch('month')||{}
    {
        week: {
            week: Date.today.strftime('%U').to_i,
            items: week_rank.map { |k, v| {user: User.find_by(id: k).summary_json, likes: v} }
        },
        month: {
            items: month_rank.map { |k, v| {user: User.find_by(id: k).summary_json, likes: v} }
        }
    }
  end

  def courses
    filter = '1=1'
    filter << " and course_type=#{params[:course].to_i}" if params[:course].present?
    if params[:coach].eql?('male')||params[:coach].eql?('female')
      gender = params[:coach].eql?('male') ? 0 : 1
      filter << " and coach_gender=#{gender}"
    end
    if params[:price].present?
      price_range = params[:price].split('~')
      if price_range[1].blank?
        filter << " and course_price > #{price_range[0].to_i}"
      else
        filter << " and course_price between #{price_range[0].to_i} and #{price_range[1].to_i}"
      end
    end

    case params[:sort]
      when 'price-asc'
        results = CourseAbstract.select('DISTINCT(course_id) course_id').where(filter).order(course_price: :asc)
      when 'price-desc'
        results = CourseAbstract.select('DISTINCT(course_id) course_id').where(filter).order(course_price: :desc)
      when 'distance-asc'
        results = CourseAbstract.select("st_distance(course_abstracts.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})') distance,course_id").where("st_dwithin(course_abstracts.coordinate, 'POINT(#{params[:lng]} #{params[:lat]})',150000) and #{filter}").order('distance asc').page(params[:page]||1)
      when 'sale-desc'
        results = CourseAbstract.all
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

  private
  def get_week_rank
    week_date = Date.today.at_beginning_of_week
    ranks = Like.where(like_type: Like::PERSON, created_at: week_date.prev_week..week_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    {
        week: week_date.strftime('%U').to_i,
        items: ranks.map { |rank| {user: User.find_by(id: rank[0]).summary_json, likes: rank[1]} }
    }
  end

  def get_month_rank
    month_date = Date.today
    if month_date==month_date.at_beginning_of_month
      ranks = Like.where(like_type: Like::PERSON, created_at: month_date.yesterday.at_beginning_of_month..month_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    else
      ranks = Like.where(like_type: Like::PERSON, created_at: month_date.at_beginning_of_month..month_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    end
    {
        items: ranks.map { |rank| {user: User.find_by(id: rank[0]).summary_json, likes: rank[1]} }
    }
  end

end
