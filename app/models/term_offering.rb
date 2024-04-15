class TermOffering < ApplicationRecord
  belongs_to :company
  belongs_to :term
  has_many :credits

  validates_uniqueness_of :term_id, scope: :company_id
end
