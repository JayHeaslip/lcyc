class Binnacle < ActiveRecord::Base
  has_many :pdfs, :dependent => :destroy
  accepts_nested_attributes_for :pdfs

##  def pdf_attributes=(pdf_attributes)
##    pdf_attributes.each do |attributes|
##      pdfs.build(attributes)
##    end
##  end
end
