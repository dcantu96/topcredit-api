class AddExpectedAtToPayments < ActiveRecord::Migration[7.1]
  def change
    remove_column :credits, :installation_status, :string
    rename_column :credits, :installation_date, :first_discount_date
    
    add_column :payments, :expected_at, :datetime
    add_column :payments, :expected_amount, :float
    # Remove null false to paid_at and amount columns
    change_column_null :payments, :paid_at, true
    change_column_null :payments, :amount, true
  end
end
