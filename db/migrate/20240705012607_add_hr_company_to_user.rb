class AddHrCompanyToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :hr_company, foreign_key: { to_table: :companies }
  end
end
