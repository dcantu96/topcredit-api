class AddRfcToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :rfc, :string
  end
end
