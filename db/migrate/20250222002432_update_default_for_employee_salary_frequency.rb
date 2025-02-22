class UpdateDefaultForEmployeeSalaryFrequency < ActiveRecord::Migration[7.1]
  def change
    change_column_default :companies, :employee_salary_frequency, from: 'biweekly', to: 'bi-monthly' 
  end
end
