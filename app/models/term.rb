class Term < ApplicationRecord
  has_many :term_offerings, dependent: :destroy
  has_many :companies, through: :term_offerings

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates_inclusion_of :duration_type, in: %w[bi-monthly monthly]
  validates_uniqueness_of :duration, scope: :duration_type
end
