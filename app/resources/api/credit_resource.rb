class Api::CreditResource < JSONAPI::Resource
  attributes :employee_number, :bank_account_number, :address_line_one, :address_line_two, :city, 
             :state, :postal_code, :country, :created_at, :updated_at
end