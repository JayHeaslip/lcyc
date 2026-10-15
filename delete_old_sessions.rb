cutoff_date = 1.year.ago

# Use find_in_batches or in_batches to process in chunks and avoid high memory usage
ActiveSession.where("updated_at < ?", cutoff_date).in_batches(of: 1000) do |relation|
  # delete_all issues a direct SQL DELETE statement without loading records or firing callbacks
  deleted_count = relation.delete_all
  puts "Deleted #{deleted_count} active session records."
end

puts "Finished cleanup."
