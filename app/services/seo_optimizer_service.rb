class SeoOptimizerService
  # Common stop words to remove from keyword extraction
  STOP_WORDS = %w[
    a an and are as at be by for from has he in is it its of on that the to was will with
    this these they them their there then than can could would should may might must
    have had has been being were we you your yours our ours his her hers its
    about above after again against all am an and any are aren't as at be because
    been before being below between both but by can't cannot could couldn't did
    didn't do does doesn't doing don't down during each few for from further had
    hadn't has hasn't have haven't having he he'd he'll he's her here here's hers
    herself him himself his how how's i i'd i'll i'm i've if in into is isn't it
    it's its itself let's me more most mustn't my myself no nor not of off on once
    only or other ought our ours ourselves out over own same shan't she she'd
    she'll she's should shouldn't so some such than that that's the their theirs
    them themselves then there there's these they they'd they'll they're they've
    this those through to too under until up very was wasn't we we'd we'll we're
    we've were weren't what what's when when's where where's which while who
    who's whom why why's with won't would wouldn't you you'd you'll you're you've
    your yours yourself yourselves
  ].freeze

  def initialize
    @articles = Article.all
  end

  def generate_seo_content
    Rails.logger.info "Starting SEO content generation for #{@articles.count} articles..."
    
    # Extract and process keywords from all articles
    all_keywords = extract_keywords_from_articles
    
    # Generate global SEO content
    global_seo = generate_global_seo_content(all_keywords)
    
    # Update each article with individual and global SEO content
    update_articles_with_seo(global_seo)
    
    Rails.logger.info "SEO content generation completed successfully"
    global_seo
  end

  private

  def extract_keywords_from_articles
    all_text = []
    
    @articles.each do |article|
      # Combine title and description for keyword extraction
      text_content = "#{article.title} #{article.description}".downcase
      all_text << text_content
    end
    
    # Extract keywords from combined text
    extract_keywords(all_text.join(' '))
  end

  def extract_keywords(text)
    # Remove special characters and split into words
    words = text.gsub(/[^\w\s]/, ' ').split(/\s+/)
    
    # Remove stop words and filter out short words
    filtered_words = words.reject do |word|
      word.length < 3 || STOP_WORDS.include?(word.downcase)
    end
    
    # Count word frequency
    word_frequency = filtered_words.each_with_object(Hash.new(0)) do |word, hash|
      hash[word.downcase] += 1
    end
    
    # Sort by frequency and take top keywords
    sorted_keywords = word_frequency.sort_by { |_, count| -count }
    
    # Return top 50 keywords as comma-separated string
    sorted_keywords.first(50).map(&:first).join(', ')
  end

  def generate_global_seo_content(keywords)
    # Get all titles and descriptions
    all_titles = @articles.pluck(:title).compact
    all_descriptions = @articles.pluck(:description).compact
    
    # Generate global meta title (combine titles with | separator, limit to 60 chars)
    global_meta_title = generate_meta_title(all_titles)
    
    # Generate global meta description (combine descriptions, limit to 160 chars)
    global_meta_description = generate_meta_description(all_descriptions)
    
    {
      meta_title: global_meta_title,
      meta_description: global_meta_description,
      keywords: keywords
    }
  end

  def generate_meta_title(titles)
    # Take first few titles and combine with | separator
    # Keep under 60 characters for optimal SEO
    combined_title = titles.first(3).join(' | ')
    
    if combined_title.length > 60
      # Truncate to fit within 60 characters
      combined_title = combined_title[0..56] + '...'
    end
    
    combined_title.present? ? combined_title : "Latest News & Updates | Insight Hub"
  end

  def generate_meta_description(descriptions)
    # Take first few descriptions and combine
    # Keep under 160 characters for optimal SEO
    combined_description = descriptions.first(2).join(' ')
    
    if combined_description.length > 160
      # Truncate to fit within 160 characters
      combined_description = combined_description[0..156] + '...'
    end
    
    combined_description.present? ? combined_description : "Stay updated with the latest news and trending stories from around the world. Get insights on current events, technology, business, and more."
  end

  def update_articles_with_seo(global_seo)
    @articles.find_each do |article|
      # Generate individual SEO for each article
      individual_seo = generate_individual_seo(article)
      
      # Update article with both individual and global SEO
      article.update!(
        meta_title: individual_seo[:meta_title],
        meta_description: individual_seo[:meta_description],
        keywords: individual_seo[:keywords],
        global_meta_title: global_seo[:meta_title],
        global_meta_description: global_seo[:meta_description],
        global_keywords: global_seo[:keywords]
      )
      
      Rails.logger.debug "Updated SEO for article: #{article.title}"
    end
  end

  def generate_individual_seo(article)
    # For individual articles, use their own title and description
    meta_title = article.title.length > 60 ? article.title[0..56] + '...' : article.title
    meta_description = article.description.length > 160 ? article.description[0..156] + '...' : article.description
    
    # Extract keywords from individual article
    article_text = "#{article.title} #{article.description}".downcase
    keywords = extract_keywords(article_text)
    
    {
      meta_title: meta_title,
      meta_description: meta_description,
      keywords: keywords
    }
  end
end
