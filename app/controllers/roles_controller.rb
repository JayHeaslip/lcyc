class RolesController < ApplicationController
  def index
    @roles = Role.order(:name)
  end

  def show
    @role = Role.find(params[:id])
    parent = @role.parent
    @controller_tree = {}
    generate_controller_tree(@role, @role.name)
    generate_controller_tree(parent, parent.name) if parent
  end

  def edit
    @role = Role.find(params[:id])
    parent = @role.parent
    @controller_tree = {}
    generate_controller_tree(@role, @role.name)
    generate_controller_tree(parent, parent.name) if parent
    # creates a tree of controllers with the actions for each controller
    # top level is hash of controllers
    #  next level is an array of actions
    @rights_tree = {}
    rights = Right.all
    rights.each do |r|
      @rights_tree[r.controller] ||= {}
      @rights_tree[r.controller][r.action] = r
    end
  end

  def update
    @role = Role.find(params[:id])
    rights = params[:right_ids]
    @role.rights.clear
    rights&.each do |right|
      right = Right.find(right)
      @role.rights << right
    end
    flash[:notice] = "#{@role.name} role was successfully updated." if @role.save
    redirect_to roles_path
  end

  private

  def generate_controller_tree(role, name)
    role.rights.each do |r|
      @controller_tree[r.controller] ||= {}
      @controller_tree[r.controller][r.action] = name
    end
  end
end
