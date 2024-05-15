namespace :puma do
  def puma_roles
    fetch(:puma_server_role, :app)
  end

  desc "Restart puma"
  task :restart do
    on roles(puma_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :systemctl, "--user restart puma_#{fetch(:rails_env)}"
        end
      end
    end
  end
end
