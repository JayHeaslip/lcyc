class Right < ApplicationRecord
  has_and_belongs_to_many :roles
  validates_presence_of :controller, :action, :name
  validates_uniqueness_of :name

  # Ensure that the table has one entry for each controller/action pair
  # this is intended to be run in the console whenever controllers are updated

  # RAILS_ENV=? bundle exec rails c
  # Right.synchronize_with_controllers

  def self.synchronize_with_controllers
    load_controller_files

    # look at all rights, delete ones that don't have a matching controller
    cleanup_rights_database

    # add all controller actions to rights database
    sync_with_database

    # special case - MailingsController#deliver_mail - don't check authorization on this (run in delayed job)
    find_by_name("MailingsController.deliver_mail").destroy
  end

  def self.extract_class_name(filename)
    File.basename(filename).chomp(".rb").camelize.constantize
  end

  def self.load_controller_files
    controller_files = Dir[Rails.root.to_s + "/app/controllers/*_controller.rb"]
    remove_list = [ "\/application_controller.rb", "\/admin_controller.rb", "\/unsubscribe_controller.rb",
                   "\/confirmations_controller.rb", "\/passwords_controller.rb", "\/sessions_controller.rb",
                   "\/active_sessions_controller.rb", "\/roles_controller.rb/" ]
    controller_files.delete_if do |c|
      remove_list.index { |e| /#{e}/.match(c) }
    end
    @controllers = []
    controller_files.each do |file_name|
      require file_name
      @controllers << extract_class_name(file_name)
    end
  end

  def self.cleanup_rights_database
    controllers_str_array = @controllers.map { |e| e.to_s }
    Right.all.each do |r|
      controller = r.name.gsub(/\..*/, "")
      unless controllers_str_array.include?(controller)
        # puts "removing #{r.name}"
        r.destroy
      end
    end
  end

  def self.sync_with_database
    # Find the actions in each of the controllers, and add them to the database
    @controllers.each do |controller|
      controller.public_instance_methods(false).each do |action|
        next if /return_to_main|component_update|component|^_/.match?(action)
        if where("controller = ? AND action = ?", controller.controller_path, action).empty?
          new(name: "#{controller}.#{action}", controller: controller.controller_path, action: action).save!
        end
      end
      # Check to make sure that all the rights for that controller in the database
      # still exist in the controller itself
      where([ "controller = ?", controller.controller_path ]).each do |right_to_go|
        unless controller.public_instance_methods(false).include?(right_to_go.action.to_sym)
          # puts "removing from database: #{controller.controller_path}, #{right_to_go.action}"
          right_to_go.destroy
        end
      end
    end
  end
end
