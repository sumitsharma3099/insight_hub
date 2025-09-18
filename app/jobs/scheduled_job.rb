class ScheduledJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Running scheduled job at #{Time.current}"
    
    # Check if we should fetch news (every 8 hours)
    last_fetch = Rails.cache.read('last_news_fetch')
    should_fetch = last_fetch.nil? || last_fetch < 8.hours.ago
    
    if should_fetch
      Rails.logger.info "Time to fetch news (last fetch: #{last_fetch})"
      FetchTrendingNewsWorker.perform_now
      Rails.cache.write('last_news_fetch', Time.current)
      Rails.logger.info "News fetch completed and timestamp updated"
    else
      Rails.logger.info "News fetch not needed yet (last fetch: #{last_fetch})"
    end
    
    # Schedule the next run in 1 hour
    ScheduledJob.set(wait: 1.hour).perform_later
    Rails.logger.info "Next scheduled job queued for #{1.hour.from_now}"
  end
end
