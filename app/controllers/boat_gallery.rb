class BoatGalleryController < ApplicationController
  def index
    @boats = Boat.joins(:profile_picture_attachment).with_attached_profile_picture.order(:LastName, :FirstName)
  end
end
