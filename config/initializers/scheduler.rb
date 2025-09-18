# Start the scheduled job system when the application boots
Rails.application.config.after_initialize do
  if Rails.env.production?
    # Only start in production to avoid conflicts in development
    Rails.logger.info "Starting scheduled job system..."
    
    # Start the scheduled job (it will reschedule itself)
    ScheduledJob.perform_later
    Rails.logger.info "Scheduled job system started"
  end
end
