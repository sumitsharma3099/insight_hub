namespace :cron do
  desc "Run scheduled tasks (call this from external cron)"
  task run: :environment do
    puts "Running scheduled tasks at #{Time.current}"
    
    # Check if we should fetch news (every 8 hours)
    last_fetch = Rails.cache.read('last_news_fetch')
    should_fetch = last_fetch.nil? || last_fetch < 8.hours.ago
    
    if should_fetch
      puts "Time to fetch news (last fetch: #{last_fetch})"
      FetchTrendingNewsWorker.perform_now
      Rails.cache.write('last_news_fetch', Time.current)
      puts "News fetch completed and timestamp updated"
    else
      puts "News fetch not needed yet (last fetch: #{last_fetch})"
    end
    
    puts "Scheduled tasks completed"
  end

  desc "Force fetch news (ignore timing)"
  task force_fetch: :environment do
    puts "Force fetching news..."
    FetchTrendingNewsWorker.perform_now
    Rails.cache.write('last_news_fetch', Time.current)
    puts "Force fetch completed"
  end

  desc "Show cron status"
  task status: :environment do
    last_fetch = Rails.cache.read('last_news_fetch')
    if last_fetch
      puts "Last news fetch: #{last_fetch}"
      puts "Next fetch due: #{last_fetch + 8.hours}"
      puts "Time until next fetch: #{((last_fetch + 8.hours) - Time.current) / 1.hour} hours"
    else
      puts "No news fetch recorded yet"
    end
  end
end
