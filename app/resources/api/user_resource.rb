class Api::UserResource < JSONAPI::Resource
  attributes :first_name, :last_name, :email, :phone, :password, :employee_number,
             :bank_account_number, :address_line_one, :address_line_two, :city,
             :state, :postal_code, :country, :rfc, :salary, :salary_frequency,
             :status, :identity_document, :identity_document_url, :identity_document_filename,
             :identity_document_size, :identity_document_content_type, :identity_document_uploaded_at, 
             :bank_statement, :bank_statement_url, :bank_statement_filename, :bank_statement_size,
             :bank_statement_content_type, :bank_statement_uploaded_at, :payroll_receipt, :payroll_receipt_url,
             :payroll_receipt_filename, :payroll_receipt_size, :payroll_receipt_content_type, 
             :payroll_receipt_uploaded_at, :proof_of_address, :proof_of_address_url,
             :proof_of_address_filename, :proof_of_address_size, :proof_of_address_content_type,
             :proof_of_address_uploaded_at, :created_at, :updated_at
  
  has_many :credits
  has_one :handled_by, class_name: 'User'

  filter :status, default: 'pending,invalid_documentation'

  filter :by_role, apply: ->(records, value, _options) {    
    if value[0] == nil
      return records.without_role(:admin).without_role(:requests).without_role('pre_authorizations')
    end
    records.with_role(value[0])
  }
  
  def fetchable_fields
    super - [:password, :identity_document, :bank_statement, :payroll_receipt, :proof_of_address]
  end
end