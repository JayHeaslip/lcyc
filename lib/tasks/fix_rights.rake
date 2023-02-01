namespace :db do
  desc "Synchronize rights database with controllers"
  task synchronize: :environment do
    Right.synchronize_with_controllers
  end
end
