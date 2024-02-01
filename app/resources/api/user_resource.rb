class Api::UserResource < JSONAPI::Resource
  attributes :first_name, :last_name, :email, :phone, :password, :employee_number,
             :bank_account_number, :address_line_one, :address_line_two, :city,
             :state, :postal_code, :country, :rfc, :salary, :salary_frequency,
             :status, :created_at, :updated_at
  
  has_many :credits

  filter :status, default: 'pending,invalid_documentation'

  def fetchable_fields
    super - [:password]
  end
end