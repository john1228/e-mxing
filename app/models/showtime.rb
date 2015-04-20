class Showtime<Dynamic
  default_scope { where(top: 1).order(id: :desc) }
  belongs_to :user
end