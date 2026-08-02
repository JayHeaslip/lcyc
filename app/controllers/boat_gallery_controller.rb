class BoatGalleryController < ApplicationController
  def index
    @boats = Boat.joins(:photo_attachment).with_attached_photo.order(:Name)
  end
end
