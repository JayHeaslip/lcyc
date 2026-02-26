namespace :solid_queue do
  def solid_queue_roles
    fetch(:solid_queue_role, :app)
  end

  desc "Quiet solid_queue"
  task :quiet do
    on roles(solid_queue_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, "bin/jobs", "quiet"
        end
      end
    end
  end

  desc "Stop solid_queue"
  desc "Restart solid_queue"
  task :restart do
    on roles(solid_queue_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :systemctl, "--user restart solid_queue_#{fetch(:rails_env)}"
        end
      end
    end
  end
end
