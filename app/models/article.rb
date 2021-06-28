class Article < ActiveRecord::Base

  def pretty_created_at
    created_at.strftime('%m %d %Y')
  end
end
