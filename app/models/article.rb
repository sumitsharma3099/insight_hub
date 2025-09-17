class Article < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :source, presence: true
  validates :author, presence: true
  validates :published_at, presence: true
  
  scope :recent, -> { order(published_at: :desc) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_language, ->(language) { where(language: language) }
  scope :by_country, ->(country) { where(country: country) }
  
  # SEO helper methods
  def seo_title
    meta_title.present? ? meta_title : title
  end
  
  def seo_description
    meta_description.present? ? meta_description : description
  end
  
  def seo_keywords
    keywords.present? ? keywords : ''
  end
  
  # Global SEO methods (for site-wide SEO)
  def self.global_seo_title
    first&.global_meta_title || "Latest News & Updates | Insight Hub"
  end
  
  def self.global_seo_description
    first&.global_meta_description || "Stay updated with the latest news and trending stories from around the world."
  end
  
  def self.global_seo_keywords
    first&.global_keywords || ''
  end
end
