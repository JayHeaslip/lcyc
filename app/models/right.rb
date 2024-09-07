class Right < ApplicationRecord
  has_and_belongs_to_many :roles
  validates_presence_of :controller, :action, :name
  validates_uniqueness_of :name

  # Ensure that the table has one entry for each controller/action pair
  # this is intended to be run in the console whenever controllers are updated

  # RAILS_ENV=? bundle exec rails c
  # Right.synchronize_with_controllers

  def self.synchronize_with_controllers
    # Load all the controller files (except application, admin, confirmations, unsubscribe, passwords, sessions, active_sessions)
    controller_files = Dir[Rails.root.to_s + "/app/controllers/*_controller.rb"].reject do |e|
      e =~ /\/application_controller.rb/ || e =~ /\/admin_controller.rb/ || e =~ /\/unsubscribe_controller.rb/ || e =~ /\/confirmations_controller.rb/ ||
        e =~ /\/passwords_controller.rb/ || e =~ /\/sessions_controller.rb/ || e =~ /\/active_sessions_controller.rb/ || e =~ /\/roles_controller.rb/
    end

    # we need to load all the controllers...
    controllers = []
    controller_files.each do |file_name|
      require file_name
      controllers << extract_class_name(file_name)
    end

    # look at all rights, delete ones that don't have a matching controller
    controllers_str_array = controllers.map { |e| e.to_s }
    all.each do |r|
      controller = r.name.gsub(/\..*/, "")
      unless controllers_str_array.include?(controller)
        puts "removing #{r.name}"
        r.destroy
      end
    end

    # Find the actions in each of the controllers, and add them to the database
    controllers.each do |controller|
      controller.public_instance_methods(false).each do |action|
        next if /return_to_main|component_update|component|^_/.match?(action)
        if where("controller = ? AND action = ?", controller.controller_path, action).empty?
          puts "adding to database: #{controller.controller_path}, #{action}"
          new(name: "#{controller}.#{action}", controller: controller.controller_path, action: action).save!
        end
      end
      # The following thanks to Tom Styles
      # Then check to make sure that all the rights for that controller in the database
      # still exist in the controller itself
      where([ "controller = ?", controller.controller_path ]).each do |right_to_go|
        unless controller.public_instance_methods(false).include?(right_to_go.action.to_sym)
          puts "removing from database: #{controller.controller_path}, #{right_to_go.action}"
          right_to_go.destroy
        end
      end
    end

    # special case - MailingsController#deliver_mail - don't check authorization on this (run in delayed job)
    puts "removing MailingsController.deliver_mail"
    find_by_name("MailingsController.deliver_mail").destroy
  end

  def self.extract_class_name(filename)
    File.basename(filename).chomp(".rb").camelize.constantize
  end
end
