class Api::CreditResource < JSONAPI::Resource
  attributes :created_at, :updated_at
  has_one :user
end