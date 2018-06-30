Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.backend = :active_record
Delayed::Worker.sleep_delay = 55
Delayed::Worker.read_ahead = 2
Delayed::Worker.max_attempts = 3

