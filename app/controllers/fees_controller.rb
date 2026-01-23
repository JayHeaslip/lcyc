class FeesController < ApplicationController
  def show
    @fee = Fee.instance
  end

  def edit
    @fee = Fee.instance
  end

  def update
    @fee = Fee.instance
    @fee.attributes = fee_params
    if @fee.save
      flash[:notice] = "Successfully updated fees."
      redirect_to fee_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def fee_params
    params.require(:fee).permit(:active, :associate, :inactive, :senior,
                                 :mooring_fee, :mooring_replacement_fee, :drysail_fee, :skip_docks_assessment)
  end
end
