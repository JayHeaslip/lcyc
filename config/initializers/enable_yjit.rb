# config/initializers/enable_yjit.rb
# Enable Ruby's YJIT JIT compiler after app boot for better perf (Ruby 3.3+ behavior)

if defined?(RubyVM::YJIT) && RubyVM::YJIT.respond_to?(:enable)
  # Optional: Only enable in production (or add your own condition)
  if Rails.env.production?
    RubyVM::YJIT.enable
    Rails.logger.info "YJIT enabled via initializer"
  else
    Rails.logger.debug "YJIT available but not enabled (non-production env)"
  end
else
  Rails.logger.warn "YJIT not available in this Ruby build"
end
