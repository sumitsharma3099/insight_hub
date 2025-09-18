namespace :news do
  desc "Fetch trending news from MediaStack API"
  task fetch: :environment do
    puts "Starting to fetch trending news..."
    FetchTrendingNewsWorker.perform_now
    puts "News fetch completed!"
  end

  desc "Update SEO content based on current articles"
  task update_seo: :environment do
    puts "Starting SEO update..."
    SeoUpdateWorker.perform_now
    puts "SEO update completed!"
  end

  desc "Fetch news and update SEO in sequence"
  task refresh: :environment do
    puts "Starting complete news refresh..."
    FetchTrendingNewsWorker.perform_now
    puts "News fetch completed, now updating SEO..."
    SeoUpdateWorker.perform_now
    puts "Complete refresh finished!"
  end

  desc "Show current article count and SEO status"
  task status: :environment do
    article_count = Article.count
    puts "Current articles in database: #{article_count}"
    
    if article_count > 0
      latest_article = Article.order(published_at: :desc).first
      puts "Latest article: #{latest_article.title}"
      puts "Published: #{latest_article.published_at}"
      
      # Check if SEO content exists
      if latest_article.global_meta_title.present?
        puts "SEO Status: ✅ Updated"
        puts "Global meta title: #{latest_article.global_meta_title}"
      else
        puts "SEO Status: ❌ Not updated"
      end
    else
      puts "No articles found. Run 'rails news:fetch' to fetch news."
    end
  end
end
