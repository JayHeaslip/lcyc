class BoatGalleryController < ApplicationController
  def index
    session[:authenticated_via_sso] = false
    @boats = Boat.joins(:photo_attachment).with_attached_photo.order(:Name)
  end
end
