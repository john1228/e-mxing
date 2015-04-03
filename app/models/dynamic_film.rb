class DynamicFilm < ActiveRecord::Base
  belongs_to :dynamic

  mount_uploader :cover, FilmCoverUploader
  mount_uploader :film, FilmUploader
end
