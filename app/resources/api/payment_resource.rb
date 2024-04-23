class Api::PaymentResource < JSONAPI::Resource
  attributes :amount, :number, :paid_at, :created_at, :updated_at
  has_one :credit

  filters :paid_at
end