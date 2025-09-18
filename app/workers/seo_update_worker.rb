class SeoUpdateWorker < ApplicationJob

  def perform
    Rails.logger.info "Starting SEO update process..."
    
    begin
      # Initialize SEO optimizer service
      seo_service = SeoOptimizerService.new
      
      # Generate and update SEO content
      seo_content = seo_service.generate_seo_content
      
      Rails.logger.info "SEO update completed successfully"
      Rails.logger.info "Global meta title: #{seo_content[:meta_title]}"
      Rails.logger.info "Global meta description: #{seo_content[:meta_description]}"
      Rails.logger.info "Global keywords: #{seo_content[:keywords]}"
      
    rescue => e
      Rails.logger.error "Error updating SEO content: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
  end
end
