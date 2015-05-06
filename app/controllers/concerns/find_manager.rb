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
    filters = "1=1"
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
    News.page(params[:page]||1).collect { |news| news.as_json }
  end

  def activities
    Activity.page(params[:page]||1).collect { |activity| activity.as_json }
  end

  def shows
    TypeShow.page(params[:page]||1).collect { |show| show.as_json }
  end

  def ranks
    {
        week: Rails.cache.fetch("#{Date.today.at_beginning_of_week}|week")||get_week_rank,
        month: Rails.cache.fetch("#{Date.today}|month")
    }
  end

  private
  def get_week_rank
    week_date = Date.today.at_beginning_of_week
    ranks = Like.where(like_type: Like::PERSON, created_at: week_date.prev_week..week_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    week_rank = ranks.map { |rank| {user: User.find_by(id: rank[0]).summary_json, likes: rank[1]} }
    info = {week: week_date.strftime("%U").to_i, items: week_rank}
    Rails.cache.write("#{week_date}|week", info, expires_in: 7.days)
    info
  end

  def get_month_week
    month_date = Date.today
    if month_date==month_date.at_beginning_of_month
      ranks = Like.where(like_type: Like::PERSON, created_at: month_date.yesterday.at_beginning_of_month..month_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    else
      ranks = Like.where(like_type: Like::PERSON, created_at: month_date.at_beginning_of_month..month_date).group(:liked_id).limit(50).order('count_id desc').count(:id)
    end
    month_rank = ranks.map { |rank| {user: User.find_by(id: rank[0]).summary_json, likes: rank[1]} }
    info = {items: month_rank}
    Rails.cache.write("#{report_date}|month", info, expires_in: 1.days)
    info
  end
end
