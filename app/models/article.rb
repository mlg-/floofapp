class Article < ActiveRecord::Base
  has_many :comments

  def pretty_created_at
    created_at.strftime('%m/%d/%Y')
  end
end
