namespace :deploy do

  desc "Synchroznie controllers and Rights database"
  task :synchronize => [:set_rails_env] do
    on primary(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:synchronize'
        end
      end
    end
  end

  after 'deploy:finishing', 'deploy:synchronize'
  
end
