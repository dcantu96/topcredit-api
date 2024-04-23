class AddNumberToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :number, :integer, null: false
    add_index :payments, [:number, :credit_id], unique: true
  end
end
