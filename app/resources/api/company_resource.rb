class Api::CompanyResource < JSONAPI::Resource
  attributes :name, :domain, :terms, :rate, :created_at, :updated_at
end