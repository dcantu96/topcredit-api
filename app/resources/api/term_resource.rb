class Api::TermResource < JSONAPI::Resource
  attributes :duration_type, :duration, :name, :created_at, :updated_at
  has_many :credits
  has_many :term_offerings
  has_many :companies, through: :term_offerings
end