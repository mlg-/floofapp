class Article < ActiveRecord::Base
  has_many :comments
  has_many :commenters, through: :comments, source: :user
  belongs_to :user

  scope :since_yesterday, -> { where('created_at > ?', Date.yesterday) }

  def pretty_created_at
    created_at.strftime('%m/%d/%Y')
  end
end
