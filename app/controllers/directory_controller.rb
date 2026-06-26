class DirectoryController < ApplicationController
  def index
    @members = Person.members.where(MemberType: [ "Member", "Partner" ]).order(:LastName, :FirstName)
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
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
    params.require(:person).permit(:FirstName, :LastName, :profile_picture)
  end
end
