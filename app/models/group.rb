class Group < ActiveRecord::Base
  include GroupAble
  scope :recommend, ->() {}
  attr_accessor :lng, :lat
  alias_attribute :hobby, :interests

  def interests_string
    interests_ary = interests.split(',')
    choose_interests = INTERESTS['items'].select { |item| interests_ary.include?(item['id'].to_s) }
    choose_interests.collect { |choose| choose['name'] }.join(',')
  end

  def as_json
    {
        no: id,
        easemob_id: easemob_id,
        name: name,
        avatar: group_photos.first.present? ? "#{$host}#{group_photos.first.photo.thumb.url}" : '',
        photos: group_photos.collect { |photo| {
            no: photo.id,
            thumb: $host + photo.photo.thumb.url,
            original: $host + photo.photo.url}
        },
        owner: User.find_by_mxid(owner).profile.summary_json,
        interests: interests,
        intro: intro
    }
  end

  def summary_json
    {
        no: id,
        easemob_id: easemob_id,
        name: name,
        avatar: group_photos.first.present? ? "#{$host}#{group_photos.first.photo.thumb.url}" : '',
        owner: User.find_by_mxid(owner).profile.summary_json,
        interests: interests,
        intro: intro
    }
  end
end
