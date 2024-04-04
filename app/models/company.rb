class Company < ApplicationRecord
  validates :borrowing_capacity, numericality: { greater_than: 0, less_than_or_equal_to: 1 }, allow_nil: true
  validates :domain, presence: true, format: { with: /\A[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}\z/ }
  validates :employee_salary_frequency, presence: true, inclusion: { in: %w(biweekly monthly) }
  validates :name, presence: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  
  has_many :term_offerings
  has_many :terms, through: :term_offerings
end
