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
    {
        week: get_week_rank,
        month: get_month_rank
    }
  end

  def courses
    filter = '1=1'
    filter<< " and courses.type = #{params[:type]}" if params[:type].present?
    filter << " and (profiles.identity=1 and profile.gender=#{params[:gender]}) and courses.user_id=profiles.user_id" if params[:gender].present?
    if params[:price].present?
      price_range = params[:price].split('~')
      filter << " and courses.price between #{price_range[0]} and #{price_range[1]}"
    end

    select_field = 'courses.id course_id,courses.name as course_name,courses.price course_price,courses.during course_during,courses.guarantee course_guarantee'
    sort_info = params[:sort].split('_')
    case sort_info[0]
      when 'price'
        sql = "select #{select_field} from courses,profiles where #{filter} order by courses.price #{sort_info[1]} limit 25 offset #{((params[:page]||1).to_i - 1)}"
      when 'distance'
        sql = "select #{select_field}, st_distance(address_coordinates.lonlat, 'POINT(#{lng} #{lat})') distance from address_coordinates. courses,profiles where #{filter} and st_dwithin(places.lonlat, 'POINT(#{lng} #{lat})',150000) order by distance asc limit 25 offset #{((params[:page]||1).to_i - 1)}"
      when 'sale'
        sql = "select #{select_field} from courses,profiles where #{filter}  "
    end

    result = Course.find_by_sql(sql)
    result.collect { |item|
      course_photo = CoursePhoto.find_by(course_id: item.course_id)
      {
          id: item.course_id,
          name: item.course_name,
          cover: course_photo.present? ? course_photo.photo.thumb.url : '',
          price: item.course_price,
          during: item.course_during,
          guarantee: item.course_guarantee,
          type: item.course_type,
          style: item.course_style,
          concerned: course.concerned.count
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
