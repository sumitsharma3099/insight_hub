Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  
  # Load scheduled jobs
  config.on(:startup) do
    schedule_file = Rails.root.join("config", "sidekiq_schedule.yml")
    
    if File.exist?(schedule_file) && Sidekiq.server?
      Sidekiq::Scheduler.reload_schedule!
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
