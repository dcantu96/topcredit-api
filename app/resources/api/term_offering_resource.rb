class Api::TermOfferingResource < JSONAPI::Resource
  attributes :created_at, :updated_at
  has_one :company
  has_one :term
end