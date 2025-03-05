class AddHrConfirmedAtToPayments < ActiveRecord::Migration[7.1]
  def change
    add_column :payments, :hr_confirmed_at, :datetime
  end
end
