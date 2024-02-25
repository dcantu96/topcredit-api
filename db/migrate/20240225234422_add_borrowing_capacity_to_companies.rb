class AddBorrowingCapacityToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :borrowing_capacity, :float
  end
end
