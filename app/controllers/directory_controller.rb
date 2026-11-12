class DirectoryController < ApplicationController
  before_action :check_person, only: [ :show, :edit, :update ]

  def index
    @members = Person.members.where(MemberType: [ "Member", "Partner" ]).order(:LastName, :FirstName)

    if params[:query].present?
      @members = @members.search_by_keyword(params[:query])
    end

    # Optional: Keep it sorted
    @members = @members.order(:LastName, :FirstName)
  end

  def show
    @boat = @person.membership&.boats.first
  end

  def edit
    @membership = @person.membership

    @membership.boats.build if @membership.boats.empty?
  end

  def update
    @membership = @person.membership

    if @membership.update(membership_params)
      redirect_to directory_path(@person), notice: "Directory profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def membership_params
    params.require(:membership).permit(
      :StreetAddress,
      :City,
      :State,
      :Zip,
      people_attributes: [
        :id, :FirstName, :LastName, :Committee1, :EmailAddress, :CellPhone, :HomePhone, :WorkPhone, :profile_picture, :remove_profile_picture
      ],
      boats_attributes: [
        :id, :Name, :Mfg_Size, :photo, :remove_photo
      ]
    )
  end

  def check_person
    @person = Person.find(params[:id])
    @boat = @person.membership.boats&.first
    unless (@person.MembershipID == current_user.membership) || (current_user.admin?)
      if current_user.person
        @person = current_user.person
      else
        redirect_to directory_index_path
      end
    end
  end
end
