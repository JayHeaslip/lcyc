class CommitteesController < ApplicationController
  def select
  end

  def list
    if params[:committee] == "All"
      @committee = "All"
      @people = Person.active.where(MemberType: ["Member", "Partner"]).order(:LastName)
    else
      @committee = Committee.includes(:people).find_by_Name(params[:committee] || "Boats")
      @people = @committee.people
    end
  end

  def download_all
    @people = Person.active.where(MemberType: ["Member", "Partner"]).order(:LastName)
    content = Person.committee_spreadsheet(@people)
    send_data(content, type: "text/csv", filename: "All_committees.csv")
  end

  def download
    @committee = Committee.includes(:people).find(params[:id])
    content = Person.committee_spreadsheet(@committee.people)
    send_data(content, type: "text/csv", filename: "#{@committee.Name}_committee.csv")
  end
end
