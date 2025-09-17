class NewsController < ApplicationController
  def index
    @articles = Article.all.order(published_at: :desc)
    @total_articles = Article.count
  end
end
