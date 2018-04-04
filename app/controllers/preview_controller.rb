class PreviewController < ApplicationController

  def show
    @mailing = Mailing.find(params[:id])
    @content = @mailing.body
    render layout: 'mailrobot'
  end

end
