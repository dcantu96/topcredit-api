class Api::CreditResource < JSONAPI::Resource
  attributes :status, :loan, :created_at, :updated_at
  has_one :borrower, foreign_key: 'user_id', class_name: 'User'
  has_one :term

  filter :status
end