class CommitteesController < ApplicationController

  before_action :authorize

  def download_spreadsheet
    @committee = params[:id] || 'Boats'
    content = Person.committee_spreadsheet(@committee)
    send_data(content, type: "text/csv", filename: "#{@committee}_committee.csv")
  end

  private

  def get_membership
    @membership = Membership.find(params[:membership_id])
  end

  def authorize
    if not current_user.roles?(%w(Admin Membership)) #BOG
      if current_user.membership && current_user.membership != params[:membership_id].to_i
        flash[:error] = "You are not authorized to view the page you requested."
        request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to root_path)
        return false
      else
        return true
      end
    else
      return true  #Admin & Membership
    end
  end

end
