class AddCreditDocumentationStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :contract_status, :string
    add_column :credits, :contract_rejection_reason, :string
    add_column :credits, :authorization_status, :string
    add_column :credits, :authorization_rejection_reason, :string
    add_column :credits, :payroll_receipt_status, :string
    add_column :credits, :payroll_receipt_rejection_reason, :string
  end
end
