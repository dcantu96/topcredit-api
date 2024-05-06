class AddAttrsToCredits < ActiveRecord::Migration[7.1]
  def change
    add_column :credits, :amortization, :decimal, precision: 15, scale: 2
    add_column :credits, :credit_amount, :decimal, precision: 15, scale: 2
    add_column :credits, :max_loan_amount, :decimal, precision: 15, scale: 2
  end
end
