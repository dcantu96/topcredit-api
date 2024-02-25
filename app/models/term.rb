class Term < ApplicationRecord
  has_many :term_offerings
  has_many :companies, through: :term_offerings

  validates :name, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates_inclusion_of :duration_type, in: %w( biweekly monthly yearly )
end
