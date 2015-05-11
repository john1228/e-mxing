class DynamicComment < ActiveRecord::Base
  belongs_to :dynamic
  belongs_to :user

  def as_json
    {
        content: content,
        created: created_at.to_i*1000,
        user: user.summary_json
    }
  end
end
