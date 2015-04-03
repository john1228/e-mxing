module FindConcern
  extend ActiveSupport::Concern
  private
  def dynamics
    Dynamic.order(id: :desc).page(params[:page]||1).collect { |dynamic|
      {
          dynamic: dynamic.as_json,
          user: dynamic.user.summary_json
      }
    }
  end

  def persons
    Place.nearby(params[:lng], params[:lat]).page(params[:page]).collect { |place|
      {
          person: place.profile.summary_json,
          distance: place.distance.to_i
      }
    }
  end

  def groups
    {
        recommend: Group.recommend.collect { |group| group.as_json },
        nearby: GroupPlace.close_to(params[:lng], params[:lat]).page(params[:page]).collect { |group_place|
          {
              group: group_place.group.as_json,
              distance: group_place.distance.to_i
          }
        }
    }
  end

  def services
    Place.nearby_services(params[:lng], params[:lat]).page(params[:page]).collect { |place|
      {
          service: place.profile.summary_json,
          distance: place.distance.to_i
      }
    }
  end

  def news
    News.page(params[:page]).collect { |news| news.as_json }
  end

  def activities
    Activity.page(params[:page]).collect { |activity| activity.as_json }
  end
end
