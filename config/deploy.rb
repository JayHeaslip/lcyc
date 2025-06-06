# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, "lcyc"
set :repo_url, "https://github.com/JayHeaslip/lcyc.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/odziozo/rails7/lcyc"
# set :deploy_via, :remote_cache

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", ".bundle", "config/secrets"

# Default value for default_env is {}
set :default_env, { path: "/home/odziozo/.nvm/versions/node/v18.15.0/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 8

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# install in system directory to simplify things
set :bundle_path, "/home/odziozo/.rvm/gems/ruby-3.2.0@global"

# only restart delayed_job for production
namespace :deploy do
  after :finishing, :synchronize do
    on primary fetch(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          info "Executing synchronize"
          execute :rake, :synchronize
        end
      end
    end
  end
end
