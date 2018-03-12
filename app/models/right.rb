class Right < ActiveRecord::Base

  has_and_belongs_to_many :roles
  validates_presence_of :controller, :action, :name
  validates_uniqueness_of :name

  # Ensure that the table has one entry for each controller/action pair
  # this is intended to be run in the console whenever controllers are updated
  def self.synchronize_with_controllers
    # Load all the controller files (except application)
    controller_files = Dir[Rails.root.to_s + "/app/controllers/*_controller.rb"].reject {|e| e =~ /\/application_controller.rb/}

    # we need to load all the controllers...
    controllers = []
    controller_files.each do |file_name|
      require file_name
      controllers << extract_class_name(file_name)
    end

    # Find the actions in each of the controllers, and add them to the database
    controllers.each do |controller|
      controller.public_instance_methods(false).each do |action|
        puts controller.controller_path
        puts action
        next if /return_to_main|component_update|component|^_/ =~ action
        if self.where("controller = ? AND action = ?", controller.controller_path, action).empty?
          self.new(name: "#{controller}.#{action}", controller: controller.controller_path, action: action).save!
        end
      end
      # The following thanks to Tom Styles
      # Then check to make sure that all the rights for that controller in the database
      # still exist in the controller itself
      self.where(['controller = ?', controller.controller_path]).each do |right_to_go|
        unless controller.public_instance_methods(false).include?(right_to_go.action.to_sym)
          right_to_go.destroy
        end
      end
    end
  end

  def self.extract_class_name(filename)
    File.basename(filename).chomp(".rb").camelize.constantize
  end

end
