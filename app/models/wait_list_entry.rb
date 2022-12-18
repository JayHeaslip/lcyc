class WaitListEntry < ApplicationRecord

  belongs_to :membership
  validates :date, presence: true

end
