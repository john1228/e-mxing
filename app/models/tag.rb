class Tag < ActiveRecord::Base
  enum tag: [:venues, :course, :dynamic, :news]
  mount_uploader :background, ImagesUploader

  class << self
    def tags_for_select
      tags.map { |tag,|
        [I18n.t(tag, scope: [:enums, :tag, :tag]), tag]
      }
    end
  end
end