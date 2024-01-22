class CreateCredits < ActiveRecord::Migration[7.1]
  def change
    create_table :credits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :employee_number
      t.string :bank_account_number
      t.string :address_line_one
      t.string :address_line_two
      t.string :city
      t.string :state
      t.integer :postal_code
      t.string :country

      t.timestamps
    end
  end
end
