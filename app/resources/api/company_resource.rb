class Api::CompanyResource < JSONAPI::Resource
  attributes :name,
             :domain,
             :borrowing_capacity,
             :rate,
             :employee_salary_frequency,
             :created_at,
             :updated_at
  has_many :term_offerings
  has_many :terms, through: :term_offerings
  has_many :credits, through: :term_offerings
  has_many :payments, through: :credits
  has_many :hr_users, class_name: "User", foreign_key: "hr_company_id"

  filter :domain
end
