class TermOffering < ApplicationRecord
  belongs_to :company
  belongs_to :term
  has_many :credits
end
