class AddUserDocumentationStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :identity_document_status, :string
    add_column :users, :identity_document_rejection_reason, :string
    add_column :users, :bank_statement_status, :string
    add_column :users, :bank_statement_rejection_reason, :string
    add_column :users, :payroll_receipt_status, :string
    add_column :users, :payroll_receipt_rejection_reason, :string
    add_column :users, :proof_of_address_status, :string
    add_column :users, :proof_of_address_rejection_reason, :string
  end
end
