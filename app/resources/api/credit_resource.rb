class Api::CreditResource < JSONAPI::Resource
  attributes :status, :loan, :contract, :contract_url, :contract_filename, 
             :contract_size, :contract_content_type, :contract_uploaded_at,
             :authorization, :authorization_url, :authorization_filename,
             :authorization_size, :authorization_content_type, :authorization_uploaded_at,
             :payroll_receipt, :payroll_receipt_url, :payroll_receipt_filename,
             :payroll_receipt_size, :payroll_receipt_content_type, :payroll_receipt_uploaded_at,
             :reason, :created_at, :updated_at
  has_one :borrower, foreign_key: 'user_id', class_name: 'User'
  has_one :term

  filter :status

  def fetchable_fields
    super - [:contract, :authorization, :payroll_receipt]
  end
end