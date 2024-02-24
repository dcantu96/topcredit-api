class Term < ApplicationRecord
  has_many :term_offerings
  has_many :companies, through: :term_offerings

  validates :name, presence: true
  validates_inclusion_of :type, in: %w( biweekly monthly yearly )
end
