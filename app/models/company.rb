class Company < ApplicationRecord
  has_many :term_offerings
  has_many :terms, through: :term_offerings
  has_many :credits, through: :term_offerings
  has_many :payments, through: :credits
  has_many :hr_users, class_name: "User", foreign_key: "hr_company_id"

  validates_uniqueness_of :domain
  validates_uniqueness_of :name
  validates :borrowing_capacity,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: 1
            },
            allow_nil: true
  validates :domain,
            presence: true,
            format: {
              with: /\A[a-zA-Z0-9_-]+(\.[a-zA-Z]{2,})+\z/
            }
  validates :employee_salary_frequency,
            presence: true,
            inclusion: {
              in: %w[bi-monthly monthly]
            }
  validates :name, presence: true
  validates :rate,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            }
  validate :validate_enabled_terms

  def validate_enabled_terms
    # Determine the required duration type based on employee salary frequency
    required_duration_type =
      employee_salary_frequency == "bi-monthly" ? "bi-monthly" : "monthly"
    required_duration_type_label =
      employee_salary_frequency == "bi-monthly" ? "quincenal" : "mensual"

    # Fetch only enabled term offerings
    enabled_terms =
      terms.joins(:term_offerings).where(term_offerings: { enabled: true })

    # Validate that all enabled term offerings have the correct duration type
    if enabled_terms.exists? &&
         enabled_terms.where.not(duration_type: required_duration_type).exists?
      errors.add(:terms, :invalid_terms, type: required_duration_type_label)
    end
  end

  def rate_with_tax
    Payments.interest_rate_with_tax(rate)
  end
end
