class InitiationInstallment < ApplicationRecord
  belongs_to :membership, optional: true
end
