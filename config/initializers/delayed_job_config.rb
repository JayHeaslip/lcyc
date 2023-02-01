Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger = Logger.new(File.join(Rails.root, "log", "delayed_job.log"))
Delayed::Worker.backend = :active_record
Delayed::Worker.sleep_delay = 30
Delayed::Worker.read_ahead = 2
Delayed::Worker.max_attempts = 3

# note: this overrides config.log_level
::ActiveRecord::Base.logger.level = Logger::INFO
