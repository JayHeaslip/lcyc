class RolesController < ApplicationController
  
  def index
    @roles = Role.order(:name)
  end

  def show
    @role = Role.find(params[:id])
    generate_controller_tree
  end

  def edit
    @role = Role.find(params[:id])
    generate_controller_tree
    # creates a tree of controllers with the actions for each controller
    # top level is hash of controllers
    #  next level is an array of actions
    @rights_tree= {}
    rights= Right.all
    rights.each do |r|
      @rights_tree[r.controller] ||= {}
      @rights_tree[r.controller][r.action] = r
    end
  end

  def update
    @role = Role.find(params[:id])
    rights= params[:right_ids]
    @role.rights.clear
    rights&.each do |right|
        right= Right.find(right)
        @role.rights << right
    end
    flash[:notice] = "#{@role.name} role was successfully updated." if @role.save
    logger.info @role.errors.full_messages.to_sentence
    logger.info flash[:notice]
    redirect_to roles_path
  end

  def destroy
    role = Role.find(params[:id])
    flash[:notice] = "Deleted #{role.name} role."
    role.destroy
    redirect_to roles_path
  end

  private

  def generate_controller_tree
    @controller_tree = {}
    @role.rights.each do |r|
      @controller_tree[r.controller] ||= {}
      @controller_tree[r.controller][r.action] = true
    end
  end
  
end
