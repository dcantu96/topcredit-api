class Api::CompanyResource < JSONAPI::Resource
  attributes :name, :domain, :rate, :created_at, :updated_at
  has_many :term_offerings
  has_many :terms, through: :term_offerings
end