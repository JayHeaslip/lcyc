class DirectoryController < ApplicationController

  before_action :check_person, only: [:edit, :update]
  
  def index
    @members = Person.members.where(MemberType: [ "Member", "Partner" ]).order(:LastName, :FirstName)
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
  end

  def update
    @person.update(person_params)
    if @person.save
      flash[:notice] = "Update successful."
      redirect_to directory_path(@person)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def person_params
    params.require(:person).permit(:FirstName, :LastName, :EmailAddress, :CellPhone, :profile_picture)
  end

  def check_person
    @person = Person.find(params[:id])
    if @person != Current.user.person
      flash[:alert] = "You are not authorized to view the page you requested."
      redirect_to directory_index_path
    end
  end
end
