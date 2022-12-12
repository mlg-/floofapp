class User < ActiveRecord::Base
  has_many :comments
  has_many :articles

  validates :first_name, format: { with: /\A[a-zA-Z]+\z/, message: 'only allows letters' }
end
