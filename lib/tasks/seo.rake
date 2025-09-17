namespace :seo do
  desc "Update SEO content for all articles"
  task update: :environment do
    puts "Starting SEO update..."
    
    begin
      seo_service = SeoOptimizerService.new
      seo_content = seo_service.generate_seo_content
      
      puts "SEO update completed successfully!"
      puts "Global meta title: #{seo_content[:meta_title]}"
      puts "Global meta description: #{seo_content[:meta_description]}"
      puts "Global keywords: #{seo_content[:keywords]}"
      
    rescue => e
      puts "Error updating SEO content: #{e.message}"
      puts e.backtrace.join("\n")
    end
  end
  
  desc "Show current SEO content"
  task show: :environment do
    puts "Current SEO Content:"
    puts "==================="
    puts "Global Title: #{Article.global_seo_title}"
    puts "Global Description: #{Article.global_seo_description}"
    puts "Global Keywords: #{Article.global_seo_keywords}"
    puts ""
    puts "Total Articles: #{Article.count}"
    
    if Article.count > 0
      puts ""
      puts "Sample Article SEO:"
      article = Article.first
      puts "Title: #{article.seo_title}"
      puts "Description: #{article.seo_description}"
      puts "Keywords: #{article.seo_keywords}"
    end
  end
end
