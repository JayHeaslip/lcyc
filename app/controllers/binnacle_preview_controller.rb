class BinnaclePreviewController < ApplicationController

  def show
    @binnacle = Binnacle.find(params[:id])
    @content = @binnacle.body
    render layout: 'mailrobot'
  end

end
