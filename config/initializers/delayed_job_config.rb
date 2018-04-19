Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger = Rails.logger
Delayed::Worker.backend = :active_record
Delayed::Worker.sleep_delay = 30
Delayed::Worker.read_ahead = 2
Delayed::Worker.max_attempts = 3

