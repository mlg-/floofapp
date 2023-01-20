class ArticlesController < ApplicationController
  before_action :login_please, only: [:new, :create]

  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  def new
    @article = Article.new
    @users = User.all.map { |u| [ u.email, u.id ] }
  end

  def create
    article = Article.create(article_params)
    if article.persisted?
      redirect_to articles_path
    else
      render :new
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :user_id)
  end

  def login_please
    redirect_to articles_path unless session_user
  end

  def session_user
    false
  end
end
