class GalleryController < ApplicationController
  def index
    @people = Person.joins(:profile_picture_attachment).with_attached_profile_picture
  end
end
