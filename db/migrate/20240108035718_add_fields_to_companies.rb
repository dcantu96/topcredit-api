class AddFieldsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :terms, :string
    add_column :companies, :rate, :float
  end
end
