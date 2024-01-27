class AddFieldsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :employee_number, :string
    add_column :users, :bank_account_number, :string
    add_column :users, :address_line_one, :string
    add_column :users, :address_line_two, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :postal_code, :integer
    add_column :users, :country, :string
  end
end