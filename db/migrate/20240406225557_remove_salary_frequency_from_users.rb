class RemoveSalaryFrequencyFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :salary_frequency, :string
  end
end
