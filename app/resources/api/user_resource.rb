class Api::UserResource < JSONAPI::Resource
  attributes :first_name, :last_name, :email, :phone, :password, :employee_number,
             :bank_account_number, :address_line_one, :address_line_two, :city,
             :state, :postal_code, :country, :rfc, :salary, :salary_frequency,
             :status, :created_at, :updated_at
  
  has_many :credits
  has_one :handled_by, class_name: 'User'

  filter :status, default: 'pending,invalid_documentation'

  filter :by_role, apply: ->(records, value, _options) {    
    if value[0] == nil
      return records.without_role(:admin).without_role(:requests)
    end
    records.with_role(value[0])
  }
  
  def fetchable_fields
    super - [:password]
  end
end