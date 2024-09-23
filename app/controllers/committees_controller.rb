class CommitteesController < ApplicationController
  def select; end

  def list
    if params[:committee] == "All"
      @committee = "All"
      @people = Person.active.where(MemberType: %w[Member Partner]).order(:LastName)
    else
      @committee = params[:committee] || "Boats"
      @people = Person.active.where(MemberType: %w[Member Partner]).committee(@committee).order(:LastName)
    end
  end

  def download_all
    @people = Person.active.where(MemberType: %w[Member Partner]).order(:LastName)
    content = Person.committee_spreadsheet(@people)
    send_data(content, type: "text/csv", filename: "All_committees.csv")
  end

  def download
    @committee = params[:id]
    @people = Person.active.where(MemberType: %w[Member Partner]).committee(@committee).order(:LastName)
    content = Person.committee_spreadsheet(@people)
    send_data(content, type: "text/csv", filename: "#{params[:id]}_committee.csv")
  end
end
