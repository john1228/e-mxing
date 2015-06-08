class ServiceTrack<Track
  belongs_to :service, foreign_key: :user_id
  has_many :appointments, foreign_key: :track_id, dependent: :destroy

  attr_accessor :dummy_start


  def as_json
    coach = Coach.find_by(id: coach_id)
    {
        no: id,
        track_type: type,
        name: name,
        intro: intro,
        address: address,
        start: start.strftime('%Y-%m-%d %H:%M'),
        during: during,
        avail: places-appointments.count,
        free: free,
        gyms: coach.nil? ? {} : {
            mxid: coach.profile_mxid,
            name: coach.profile_name,
            tags: coach.profile_tags
        }
    }
  end
end