class AddSalaryFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :salary, :integer
    add_column :users, :salary_frequency, :string
  end
end
