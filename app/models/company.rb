class Company < ApplicationRecord
  validates :name, presence: true
  validates :domain, presence: true, format: { with: /\A[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}\z/ }
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :borrowing_capacity, numericality: { greater_than: 0, less_than_or_equal_to: 1 }, allow_nil: true
  
  has_many :term_offerings
  has_many :terms, through: :term_offerings
end
