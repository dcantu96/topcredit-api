class AddReasonToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reason, :string
  end
end
