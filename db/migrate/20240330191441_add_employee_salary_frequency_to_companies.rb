class AddEmployeeSalaryFrequencyToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :employee_salary_frequency, :string, null: false, default: 'biweekly'
  end
end
