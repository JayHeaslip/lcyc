class RolesController < ApplicationController
  
  def index
    @roles = Role.order(:name)
  end

  def show
    @role = Role.find(params[:id])
    @controller_tree = {}
    @role.rights.each do |r|
      @controller_tree[r.controller] ||= {}
      @controller_tree[r.controller][r.action] = true
    end
  end

  def edit
    @role = Role.find(params[:id])
    @controller_tree = {}
    @role.rights.each do |r|
      @controller_tree[r.controller] ||= {}
      @controller_tree[r.controller][r.action] = true
    end
    # creates a tree of controllers with the actions for each controller
    # top level is hash of controllers
    #  next level is an array of actions
    @rights_tree= {}
    rights= Right.all
    rights.each do |r|
      name= r.controller
      @rights_tree[name] ||= {}
      if @controller_tree.include?(name) &&
          @controller_tree[name][r.action]
        v = true
      else
        v = false
      end
      @rights_tree[name][r.action] = v
    end
  end

  def update
    @role = Role.find(params[:id])
    rights= params['right']
    unless rights.nil?
      @role.rights.clear
      rights.each do |controller, actions|
        actions.each do |action|
          right= Right.find_by_controller_and_action(controller, action)
          @role.rights << right
        end
      end
    end
    flash[:notice] = 'Role was successfully updated.' if @role.save
    render @role
  end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    redirect_to roles_path
  end

end
