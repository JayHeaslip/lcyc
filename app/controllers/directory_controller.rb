class DirectoryController < ApplicationController
  before_action :check_person, only: [ :edit, :update ]

  def index
    @members = Person.members.where(MemberType: [ "Member", "Partner" ]).order(:LastName, :FirstName)

    if params[:query].present?
      @members = @members.search_by_keyword(params[:query])
    end

    # Optional: Keep it sorted
    @members = @members.order(:LastName, :FirstName)
  end

  def show
    @person = Person.find(params[:id])
    @boat = @person.membership&.boats.first
  end

  def edit
    @person = Person.find(params[:id])
    @membership = @person.membership

    @membership.boats.build if @membership.boats.empty?
  end

  def update
    @person = Person.find(params[:id])
    @membership = @person.membership

    if @membership.update(membership_params)
      redirect_to directory_path(@person), notice: "Directory profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def membership_params
    # 1. Tell permit that people_attributes and boats_attributes are expected hashes
    permitted = params.require(:membership).permit(
      :StreetAddress, :City, :State, :Zip,
      people_attributes: {},
      boats_attributes: {}
    )

    # 2. Manually permit the custom string-keyed ("person") fields inside people_attributes
    if params[:membership][:people_attributes].present?
      permitted[:people_attributes] = params[:membership][:people_attributes].to_unsafe_h.transform_values do |person_params|
        if person_params[:remove_profile_picture] == "1" && person_params[:id].present?
          person = Person.find_by(id: person_params[:id])
          person.profile_picture.purge_later if person&.profile_picture&.attached?
        end

        ActionController::Parameters.new(person_params).permit(
          :id, :FirstName, :LastName, :EmailAddress, :CellPhone, :profile_picture
        )
      end
    end

    # 3. Manually permit the custom string-keyed ("boat") fields inside boats_attributes
    if params[:membership][:boats_attributes].present?
      permitted[:boats_attributes] = params[:membership][:boats_attributes].to_unsafe_h.transform_values do |boat_params|
        if boat_params[:remove_photo] == "1" && boat_params[:id].present?
          boat = Boat.find_by(id: boat_params[:id])
          boat.photo.purge_later if boat&.photo&.attached?
        end

        ActionController::Parameters.new(boat_params).permit(
          :id, :Name, :Mfg_Size, :photo
      )
      end
    end
    permitted
  end

  def check_person
    @person = Person.find(params[:id])
    @boat = @person.membership.boats&.first
    unless (@person == current_user.person) || (current_user.admin?)
      flash[:alert] = "You are not authorized to view the page you requested."
      redirect_to directory_index_path
    end
  end
end
