class RemoveFieldsFromCredits < ActiveRecord::Migration[7.1]
  def change
    remove_column :credits, :employee_number, :string
    remove_column :credits, :bank_account_number, :string
    remove_column :credits, :address_line_one, :string
    remove_column :credits, :address_line_two, :string
    remove_column :credits, :city, :string
    remove_column :credits, :state, :string
    remove_column :credits, :postal_code, :integer
    remove_column :credits, :country, :string
  end
end