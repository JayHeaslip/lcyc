class GalleryController < ApplicationController
  def index
    session[:authenticated_via_sso] = false
    @people = Person.joins(:profile_picture_attachment).with_attached_profile_picture.order(:LastName, :FirstName)
  end
end
