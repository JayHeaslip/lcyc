# -*- coding: utf-8 -*-

desc "Synchronize rights database with controllers"
task synchronize: :environment do
  Right.synchronize_with_controllers
end
