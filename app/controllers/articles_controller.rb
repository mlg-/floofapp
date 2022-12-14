class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  def new
    @article = Article.new
    @users = User.all.map { |u| [ u.email, u.id ] }
  end
  end
end
