require 'net/http'
require 'json'
require 'uri'

class FetchTrendingNewsWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info "Starting to fetch trending news from MediaStack API..."
    
    begin
      # MediaStack API endpoint with your access key
      access_key = "266cb18a9dd4981a0f3f2491db8a5240"
      # Fetch only English news, sorted by popularity, limit to 100 articles
      url = URI("https://api.mediastack.com/v1/news?access_key=#{access_key}&limit=100&languages=en&sort=popularity")
      
      Rails.logger.info "Fetching from URL: #{url}"
      
      # Make HTTP request
      response = Net::HTTP.get_response(url)
      
      if response.code == '200'
        data = JSON.parse(response.body)
        
        if data['data'] && data['data'].is_a?(Array)
          articles_count = data['data'].length
          Rails.logger.info "Successfully fetched #{articles_count} articles from MediaStack API"
          
          # Delete all existing articles before adding new ones
          Rails.logger.info "Deleting all existing articles..."
          Article.delete_all
          Rails.logger.info "Deleted all existing articles"
          
          # Process each article
          data['data'].each_with_index do |article_data, index|
            begin
              # Create new article (no need to check for duplicates since we deleted all)
              article = Article.create!(
                author: article_data['author'].present? ? article_data['author'] : 'Unknown',
                title: article_data['title'],
                description: article_data['description'],
                url: article_data['url'],
                source: article_data['source'],
                image: validate_image_url(article_data['image']),
                category: article_data['category'] || 'general',
                language: article_data['language'] || 'en',
                country: article_data['country'] || 'us',
                published_at: parse_published_at(article_data['published_at'])
              )
              
              Rails.logger.debug "Saved article #{index + 1}: #{article.title}"
              
            rescue => e
              Rails.logger.error "Error processing article #{index + 1}: #{e.message}"
              next
            end
          end
          
          Rails.logger.info "Completed processing #{articles_count} articles"
          
          # Trigger SEO update after news are updated
          Rails.logger.info "Triggering SEO update..."
          SeoUpdateWorker.perform_async
          
        else
          Rails.logger.error "No data received from MediaStack API or invalid response format"
        end
      else
        Rails.logger.error "MediaStack API request failed with status: #{response.code} - #{response.message}"
        Rails.logger.error "Response body: #{response.body}"
      end
      
    rescue => e
      Rails.logger.error "Error fetching trending news: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  private

  def validate_image_url(image_url)
    return nil if image_url.blank?
    
    begin
      # Check if URL is valid format
      uri = URI.parse(image_url)
      return nil unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      
      # Make a HEAD request to check if image exists and is accessible
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', 
                                open_timeout: 5, read_timeout: 5) do |http|
        request = Net::HTTP::Head.new(uri)
        request['User-Agent'] = 'Mozilla/5.0 (compatible; NewsBot/1.0)'
        http.request(request)
      end
      
      # Check if response is successful and content type is an image
      if response.code == '200' && response['content-type']&.start_with?('image/')
        Rails.logger.debug "Valid image URL: #{image_url}"
        image_url
      else
        Rails.logger.debug "Invalid image URL (status: #{response.code}, content-type: #{response['content-type']}): #{image_url}"
        nil
      end
      
    rescue => e
      Rails.logger.debug "Error validating image URL #{image_url}: #{e.message}"
      nil
    end
  end

  def parse_published_at(published_at_string)
    return nil if published_at_string.blank?
    
    begin
      # Parse ISO 8601 format: "2020-08-05T05:47:24+00:00"
      DateTime.parse(published_at_string)
    rescue ArgumentError => e
      Rails.logger.warn "Failed to parse published_at: #{published_at_string} - #{e.message}"
      nil
    end
  end
end
