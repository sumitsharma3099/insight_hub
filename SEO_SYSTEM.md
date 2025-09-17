# Automated SEO System for Insight Hub

## Overview
This automated SEO system updates your website's search engine optimization every time your news are refreshed (every 8 hours). It extracts keywords from article titles and descriptions, removes stop words, and generates dynamic meta tags.

## How It Works

### 1. **Automatic Trigger**
- When `FetchTrendingNewsWorker` completes fetching news, it automatically triggers `SeoUpdateWorker`
- SEO updates run every 8 hours (30 minutes after news fetch)
- No manual intervention required

### 2. **Keyword Extraction Process**
- Combines all article titles and descriptions
- Removes common stop words (a, an, the, is, are, etc.)
- Filters out words shorter than 3 characters
- Counts word frequency and selects top 50 keywords
- Creates unique, relevant keyword lists

### 3. **Meta Tag Generation**
- **Global Meta Title**: Combines top 3 article titles with "|" separator (max 60 chars)
- **Global Meta Description**: Combines top 2 article descriptions (max 160 chars)
- **Individual Article SEO**: Each article gets its own optimized meta tags
- **Fallback Content**: Default SEO content if no articles exist

### 4. **SEO Fields Added to Articles**
- `meta_title`: Individual article meta title
- `meta_description`: Individual article meta description  
- `keywords`: Individual article keywords
- `global_meta_title`: Site-wide meta title
- `global_meta_description`: Site-wide meta description
- `global_keywords`: Site-wide keywords

## Files Created/Modified

### New Files:
- `app/services/seo_optimizer_service.rb` - Core SEO logic
- `app/workers/seo_update_worker.rb` - Background SEO processing
- `lib/tasks/seo.rake` - Manual SEO management tasks

### Modified Files:
- `app/models/article.rb` - Added SEO helper methods
- `app/workers/fetch_trending_news_worker.rb` - Triggers SEO updates
- `app/views/layouts/application.html.erb` - Dynamic meta tags
- `app/views/news/index.html.erb` - SEO content integration
- `config/sidekiq_schedule.yml` - SEO scheduling
- `db/migrate/20250917155016_add_seo_fields_to_articles.rb` - Database schema

## Usage

### Automatic Operation
The system runs automatically every 8 hours. No action required.

### Manual Operations
```bash
# Update SEO content manually
rails seo:update

# View current SEO content
rails seo:show

# Trigger SEO update from Rails console
SeoUpdateWorker.perform_async
```

### Viewing SEO Content
- Visit your website and view page source to see generated meta tags
- Check Rails logs for SEO update confirmations
- Use `rails seo:show` to see current SEO content

## SEO Features Implemented

### 1. **Dynamic Meta Tags**
- Title, description, and keywords update automatically
- Open Graph tags for social media sharing
- Twitter Card meta tags
- Proper character limits for optimal SEO

### 2. **Keyword Optimization**
- Automatic stop word removal
- Frequency-based keyword selection
- Unique keyword generation
- Contextual relevance

### 3. **Content Optimization**
- Title combination with "|" separator
- Description truncation to optimal length
- Fallback content for empty states
- Individual and global SEO content

### 4. **Technical SEO**
- Proper meta tag structure
- Social media optimization
- Mobile-friendly meta tags
- Search engine friendly formatting

## Monitoring

### Logs to Watch
```bash
# Check Sidekiq logs for SEO updates
tail -f log/development.log | grep -i seo

# Check for SEO worker completion
tail -f log/development.log | grep "SEO update completed"
```

### Database Queries
```ruby
# Check SEO content in Rails console
Article.first.global_meta_title
Article.first.global_meta_description
Article.first.global_keywords
```

## Benefits

1. **Fully Automated**: No manual SEO work required
2. **Always Fresh**: SEO updates with every news refresh
3. **Keyword Rich**: Extracts relevant keywords from actual content
4. **Search Engine Optimized**: Proper meta tag structure and limits
5. **Social Media Ready**: Open Graph and Twitter Card support
6. **Scalable**: Handles any number of articles automatically

## Next Steps

1. **Start Sidekiq**: `bundle exec sidekiq` to enable background processing
2. **Test the System**: Run `rails seo:update` to generate initial SEO content
3. **Monitor Performance**: Check logs and database for SEO updates
4. **Customize**: Modify stop words or keyword limits in `SeoOptimizerService`

The system is now fully operational and will automatically optimize your SEO every time your news are updated!