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

  def courses(type, coach, price, sort)
    filter = '1=1'
    filter<< " and courses.type = #{params[:type]}" if params[:type].present?
    filter<< " and courses.type = #{params[:type]}" if params[:coach].present?
    filter<< " and courses.type = #{params[:type]}" if params[:price].present?

    select = 'select courses.id course_id,courses.name as course_name,courses.price course_price,courses.during course_during,courses.guarantee course_gu'

    case sort
      when 'price'
        sql = 'select courses.id course'
      when 'distance'
      when 'sale'
    end

    AddressCoordinate.nearby(params[:lng], params[:lat], params[:page]||1).collect { |item|
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
